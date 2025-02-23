//author: Sang Do
import 'package:ai_travel_planner/db/city_model.dart';
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
        cache_trip_date TINYTEXT,
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
  //get cities by uuids
  Future<List<Map>> queryCitiesIn(List<dynamic> uuids) async {
    Database db = await instance.db;
    return await db.query('tb_city', columns: ['*'], 
      where: 'uuid IN (${uuids.map((e) => "?").join(', ')})', 
      whereArgs: uuids);
  }

  //update or insert cities at once
  Future<void> upsertBatch(List<City> cities) async {
    var dbBatch = _database?.batch();
    List<City> list2Insert = [];
    List<City> list2Update = [];
    List<String> uuids = [];  //all uuids
    Map<String, City> citiesMap = {};  //key: uuid, value: city detail
    for (City city in cities){
      uuids.add(city.uuid);
      citiesMap[city.uuid] = city;
    }
    //
    if (dbBatch != null){
      final dbCities = await DatabaseHelper.instance.queryCitiesIn(uuids);
      if (dbCities.isNotEmpty){
        List<String> uuidsInDb = [];  //all uuids in db
        for (Map dbCity in dbCities){
          uuidsInDb.add(dbCity['uuid']);
          if (uuids.contains(dbCity['uuid']) && citiesMap[dbCity['uuid']] != null){
            list2Update.add(citiesMap[dbCity['uuid']]!);  //update new city detail
          }
        }
        for (City city in cities){
          if (!uuidsInDb.contains(city.uuid)){
            list2Insert.add(city);  //new city
          }
        }
      } else {
        //nothing in db, insert all
        for (City city in cities){
          list2Insert.add(city);
        }
      }
    } else {
      debugPrint('dbBatch null ');
    }
    debugPrint('list2Insert ' + list2Insert.length.toString());
    debugPrint('list2Update ' + list2Update.length.toString());

    if (list2Insert.isNotEmpty){
      for (City city in list2Insert){
        dbBatch?.insert('tb_city', city.toMap());
      }
    }
    if (list2Update.isNotEmpty){
      for (City city in list2Update){
        dbBatch?.update('tb_city', city.toMap(), where: 'uuid = ?', whereArgs: [city.uuid]);
      }
    }
    await dbBatch?.commit();
  }
}
