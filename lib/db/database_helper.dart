//author: Sang Do
import 'package:ai_travel_planner/db/city_model.dart';
import 'package:ai_travel_planner/functions.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'metadata_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'travelgen_ai_planner.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE metadata (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TINYTEXT,
        gem_key TINYTEXT,
        gem_uri TINYTEXT,
        backend_uri TINYTEXT,
        update_time INTEGER,
        home_cities TEXT,
        hotel_booking_aff_id TINYTEXT,
        wonder_uri TINYTEXT,
        wonder_alias_uri TINYTEXT,
        trip_uri TINYTEXT,
        android_version TINYTEXT,
        ios_version TINYTEXT,
        cities_url TINYTEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE tb_city (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TINYTEXT,
        name TINYTEXT,
        country TINYTEXT,
        continent TINYTEXT,
        review INTEGER,
        img TINYTEXT,
        city_id INTEGER,
        imgUrls TEXT,
        wonder_id TINYTEXT,
        travel_date TINYTEXT,
        wonder_trip_id TINYTEXT
      )
    ''');
  }

  Future<List<Map>> rawQuery(String query, List<String> conditions) async {
    // debugPrint(query);
    Database db = await instance.db;
    return await db.rawQuery(query, conditions);
  }

  /////////////// METADATA
  Future<int> insertMetadata(MetaDataModel newMetadata) async {
    Database db = await instance.db;
    return await db.insert('metadata', newMetadata.toMap());
  }
  Future<int> updateMetadata(MetaDataModel newMetadata) async {
    Database db = await instance.db;
    return await db.update('metadata', newMetadata.toMap(), where: 'uuid = ?', whereArgs: [newMetadata.uuid]);
  }
  /////////////// CITY DATA (saved in the local app, not cloud)
  Future<int> deleteAll() async {
    Database db = await instance.db;
    return await db.delete('tb_city');
  }
  //
  Future<int> updateCitydata(City cityData) async {
    Database db = await instance.db;
    return await db.update('tb_city', cityData.toMap(), where: 'uuid = ?', whereArgs: [cityData.uuid]);
  }
  //get ALL cities
  Future<List<Map>> getAllCities() async {
    Database db = await instance.db;
    return await db.query('tb_city');
  }
  //get cities by uuids
  Future<List<Map>> queryCitiesIn(List<dynamic> uuids) async {
    Database db = await instance.db;
    return await db.query('tb_city', columns: ['*'], 
      where: 'uuid IN (${uuids.map((e) => "?").join(', ')})', 
      whereArgs: uuids);
  }

  Future<void> insertBatch(List<City> paramCities) async {
    var dbBatch = _database?.batch();
    for (City city in paramCities){
      dbBatch?.insert('tb_city', city.toMap());
    }
    debugPrint('Insert all ' + paramCities.length.toString());
    await dbBatch?.commit();
  }

  //update or insert cities at once
  Future<void> upsertBatch(List<City> paramCities) async {
    var dbBatch = _database?.batch();
    List<City> list2Insert = [];
    List<City> list2Update = [];
    List<String> cityCountriesInParams = [];  //all "city@country" in params
    Map<String, City> citiesMapInParams = {};  //key: "city@country", value: city detail
    for (City city in paramCities){
      cityCountriesInParams.add(cityAtCountry(city.name, city.country));
      citiesMapInParams[cityAtCountry(city.name, city.country)] = city;
    }
    //
    if (dbBatch != null){
      final dbCities = await DatabaseHelper.instance.getAllCities();
      if (dbCities.isNotEmpty){
        List<String> cityCountriesInDb = [];  //all cities in db
        for (Map dbCity in dbCities){
          cityCountriesInDb.add(cityAtCountry(dbCity['name'], dbCity['country']));
          if (cityCountriesInParams.contains(cityAtCountry(dbCity['name'], dbCity['country'])) 
                && citiesMapInParams[cityAtCountry(dbCity['name'], dbCity['country'])] != null){
            list2Update.add(citiesMapInParams[cityAtCountry(dbCity['name'], dbCity['country'])]!);  //update new city detail
          }
        }
        for (City city in paramCities){
          if (!cityCountriesInDb.contains(cityAtCountry(city.name, city.country))){
            list2Insert.add(city);  //new city because it is not found in our db
          }
        }
      } else {
        //nothing in db, insert all
        for (City city in paramCities){
          list2Insert.add(city);
        }
      }
    } else {
      debugPrint('dbBatch null');
    }
    debugPrint('list2Insert ' + list2Insert.length.toString());
    debugPrint('list2Update ' + list2Update.length.toString());
    // int index = 0;
    if (list2Insert.isNotEmpty){
      for (City city in list2Insert){
        // if (index == 0 && city.img.isNotEmpty){
        //   debugPrint(city.img);
        //   index = 1;
        // }
        dbBatch?.insert('tb_city', city.toMap());
      }
    }
    if (list2Update.isNotEmpty){
      for (City city in list2Update){
        dbBatch?.update('tb_city', city.toMap(), 
            where: 'name = ? and country = ?', 
            whereArgs: [city.name, city.country]);
      }
    }
    await dbBatch?.commit();
  }
  //
  Future<List<Map>> queryCitiesByContinentPagination(String continent, int pageIndex, int pageSize) async {
    Database db = await instance.db;
    List<Map> result = await db.query('tb_city',
      columns: ['*'],
      where: 'continent = ?',
      whereArgs: [continent],
      orderBy: "review DESC",
      limit: pageSize,
      offset: pageIndex * pageSize
    );
    return result;
  }
//
//get books by categories with pagination
  Future<List<Map>> queryByContinentTotal(String continent) async {
    Database db = await instance.db;
    List<Map> result = await db.query('tb_city',
      columns: ['count(*) AS total'],
      where: 'continent = ?',
      whereArgs: [continent]
    );
    return result;
  }
  //search by keyword
  Future<List<Map>> searchByKeyword(String keyword, int pageSize) async {
    Database db = await instance.db;
    List<Map> result = await db.query('tb_city',
      columns: ['*'],
      where: 'name LIKE ? OR country LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: "name ASC",
      limit: pageSize,
      offset: 0
    );
    return result;
  }
}