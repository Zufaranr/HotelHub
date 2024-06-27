import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class BookingDatabaseService {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE hotelkeren(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        UrlToImage TEXT,
        checkIn TEXT,
        checkOut TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'hotelkeren.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
    String? title,
    String UrlToImage,
    String? checkInDate,
    String? checkOutDate,
  ) async {
    final db = await BookingDatabaseService.db();
    final data = {
      'title': title,
      'UrlToImage': UrlToImage,
      'checkIn': checkInDate,
      'checkOut': checkOutDate,
    };
    final id = await db.insert('hotelkeren', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await BookingDatabaseService.db();
    return db.query('hotelkeren', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await BookingDatabaseService.db();
    return db.query('hotelkeren', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<void> deleteItem(int id) async {
    final db = await BookingDatabaseService.db();
    try {
      await db.delete("hotelkeren", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint(
          "There was an issue encountered while attempting to remove an item: $err");
    }
  }
}
