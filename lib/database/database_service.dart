import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseService {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE hotel2(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        UrlToImage TEXT,
        category TEXT,
        deskripsi TEXT,
        lokasi TEXT,
        price TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'hotel2.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
      String? title,
      String UrlToImage,
      String? category,
      String? deskripsi,
      String? lokasi,
      String? price) async {
    final db = await DatabaseService.db();

    var tableInfo = await db.rawQuery('PRAGMA table_info(hotel)');
    for (var column in tableInfo) {
      print('Column: ${column['name']} Type: ${column['type']}');
    }
    final data = {
      'title': title,
      'UrlToImage': UrlToImage,
      'category': category,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'price': price,
    };
    final id = await db.insert('hotel2', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseService.db();
    return db.query('hotel2', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseService.db();
    return db.query('hotel2', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<void> deleteItem(int id) async {
    final db = await DatabaseService.db();
    try {
      await db.delete("hotel2", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err"); //diubah
    }
  }
}
