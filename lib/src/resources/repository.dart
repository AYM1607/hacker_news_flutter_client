import 'dart:async';

import 'news_api_provider.dart';
import 'news_db_provider.dart' show newsDbProvider;
import '../models/item_model.dart';

/// Source of data for the app.
///
/// Interfaces with sources and caches, so the values could come from network or
/// local sources.
class Repository {
  final List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  final List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  /// Returns a list of top ids.
  Future<List<int>> fetchTopIds() {
    return sources.last.fetchTopIds();
  }

  /// Returns an item model from a particular id.
  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    Source source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    caches.forEach((Cache cache) {
      // If the source that provided this item is also a cache, it's not
      // necessary to add it to itself, we use as dynamic because the cache
      // could have any type.
      if (source != cache as dynamic) {
        cache.addItem(item);
      }
    });

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
