import 'dart:async';
import 'package:hotelhub/model/hotel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'hotelhub.db');

    // Create the database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE hotel(
        id INTEGER PRIMARY KEY,
        title TEXT,
        lokasi TEXT,
        urlToImage TEXT,
        price TEXT
      )
    ''');
  }

  // Insert a hotel into the database
  Future<int> insertHotel(Hotel hotel) async {
    Database? dbClient = await db;
    return await dbClient!.insert('hotel', hotel.toMap());
  }

  // Get all hotels from the database
  Future<List<Hotel>> getHotels() async {
    Database? dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('hotel');
    return List.generate(maps.length, (i) {
      return Hotel.fromMap(maps[i]);
    });
  }

  // Delete a hotel from the database
  Future<int> deleteHotel(int id) async {
    Database? dbClient = await db;
    return await dbClient!.delete(
      'hotel',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
