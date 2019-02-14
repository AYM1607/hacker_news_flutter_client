import 'dart:async';

import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

/// Source of data for the app.
///
/// Interfaces with sources and caches, so the values could come from network or
/// local sources.
class Repository {
  final NewsApiProvider _apiProvider = NewsApiProvider();
  final NewsDbProvider _dbProvider = NewsDbProvider();

  /// Returns a list of top ids.
  Future<List<int>> fetchTopIds() {
    return _apiProvider.fetchTopIds();
  }

  /// Returns an item model from a particular id.
  Future<ItemModel> fetchItem(int id) async {
    var item = await _dbProvider.fetchItem(id);
    if (item != null) {
      return item;
    }

    item = await _apiProvider.fetchItem(id);
    _dbProvider.addItem(item);
    return item;
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}
