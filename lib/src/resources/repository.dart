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
  Future<List<int>> fetchTopIds() async {
    List<int> topIds;
    Source source;
    final time = Stopwatch()..start();
    // Some sources may require initialization time, thus, there may be some
    // situations when the first iteration over the sources returns null, even
    // if there's available sources later on. It's necessary to wait until at
    // least one of them returns a valid result or a certain time period has
    // passed.
    do {
      for (source in sources) {
        topIds = await source.fetchTopIds();
        if (topIds != null) {
          break;
        }
      }
    } while (topIds == null && time.elapsedMilliseconds < 5000);
    time.stop();

    caches.forEach(
      (Cache cache) {
        if (source != (cache as dynamic)) {
          cache.addTopIds(topIds);
        }
      },
    );

    return topIds;
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
      // necessary to add it to itself. We treat the chache as dynamic
      // to allow comparison, since a cache could be implemented by
      // multiple classes.
      if (source != (cache as dynamic)) {
        cache.addItem(item);
      }
    });

    return item;
  }

  /// Deletes all data inside all caches.
  Future<void> clearCaches() async {
    for (Cache cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<void> addTopIds(List<int> ids);
  Future<void> clear();
}
