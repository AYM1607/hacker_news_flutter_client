import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'repository.dart' show Cache, Source;
import '../models/item_model.dart';

/// An interface to the local sqlite database.
class NewsDbProvider implements Cache, Source {
  /// A connection to the database.
  Database db;

  /// Flag that indicates if the database has been initialized.
  bool get isReady => db != null;

  NewsDbProvider() {
    init();
  }

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

        newDb.execute("""
          CREATE TABLE TopIds (
            databaseId INTEGER PRIMARY KEY AUTOINCREMENT,
            id INTEGER
          )
        """);
      },
    );
  }

  // TODO: implement this functionality.
  // Returns a list of top ids from the local database.
  Future<List<int>> fetchTopIds() async {
    if (!isReady) {
      return null;
    }
    final maps = await db.query(
      "TopIds",
      where: null,
    );
    if (maps.length > 0) {
      return mapDbMapsToListOfIds(maps);
    }
    return null;
  }

  /// Returns an item from a particular id.
  Future<ItemModel> fetchItem(int id) async {
    if (!isReady) {
      return null;
    }

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

  // TODO: refactor to a [Future<int>], the [int] returned is not being used anyway.
  /// Inserts an item into the local database.
  Future<int> addItem(ItemModel item) async {
    // We dont want to attempt to insert this item if the db is not ready or if
    // the item provided is null.
    if (!isReady || item == null) {
      return 0;
    }
    return db.insert("Items", item.toDbMap());
  }

  Future<void> addTopIds(List<int> ids) async {
    // We dont want to attempt to add the ids if the db is not ready or if the
    // data provided is null.
    if (!isReady || ids == null) {
      return null;
    }
    final batch = db.batch();
    ids.forEach(
      (int id) {
        batch.insert(
          "TopIds",
          {
            "id": id,
          },
        );
      },
    );
    await batch.commit();
  }

  /// Deletes of the data inside the tables.
  Future<void> clear() async {
    if (!isReady) {
      return;
    }
    await db.delete('Items');
    await db.delete('TopIds');
  }

  List<int> mapDbMapsToListOfIds(List<Map<String, dynamic>> maps) {
    return maps
        .map(
          (map) {
            return map["id"];
          },
        )
        .toList()
        .cast<int>();
  }
}

final newsDbProvider = NewsDbProvider();
