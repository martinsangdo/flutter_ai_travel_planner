//author: Sang Do
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
        ios_version TINYTEXT
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
        imgUrls TEXT
      )
    ''');
  }

  Future<List<Map>> rawQuery(String query, List<String> conditions) async {
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
  ///
}
