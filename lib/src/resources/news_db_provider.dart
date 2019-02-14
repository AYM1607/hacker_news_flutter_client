import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/item_model.dart';

/// An interface to the local sqlite database.
class NewsDbProvider {
  /// A connection to the database.
  Database db;

  /// Initializes the database.
  ///
  /// Creates a table for the items.
  void init() async {
    final directory = await getDatabasesPath();
    final path = join(directory, "items.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE Items (
            by TEXT,
            descendants INTEGER,
            id INTEGER PRIMARY KEY,
            kids BLOB,
            score INTEGER,
            time INTEGER,
            title TEXT,
            type TEXT,
            url TEXT,
            deleted INTEGER,
            text TEXT,
            dead INTEGER,
            parent INTEGER
          ) 
        """);
      },
    );
  }

  /// Returns an item from a particular id.
  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }

    return null;
  }

  /// Inserts an item into the local database.
  Future<int> addItem(ItemModel item) {
    return db.insert("Items", item.toDbMap());
  }
}
