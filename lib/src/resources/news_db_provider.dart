import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/item_model.dart';

class NewsDbProvider {
  Database db;
  init() async {
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
}
