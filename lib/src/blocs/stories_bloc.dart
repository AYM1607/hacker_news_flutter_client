import 'package:rxdart/rxdart.dart';

import '../models/item_model.dart';
import '../resources/repository.dart';

/// A business logic component that is in charge of fetching and keeping track
/// of the top stories.
class StoriesBloc {
  final Repository _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  StoriesBloc() {
    _itemsFetcher.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  // Streams getters
  /// A stream of top ids.
  Observable<List<int>> get topIds => _topIds.stream;

  /// A stream of the cached items.
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Sinks getters
  /// Starts the process of fetching a specific item.
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  /// Transforms incoming ids into a cache that contains every fetched id.
  ScanStreamTransformer<int, Map<int, Future<ItemModel>>> _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, _) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  /// Starts the process of fetching the top ids.
  ///
  /// They're made available through the [topIds] stream.
  /// These ids could be out of date if they come from a cached source.
  Future<void> fetchTopIds() async {
    final topIds = await _repository.fetchTopIds();
    if (topIds == null) {
      _topIds.sink.addError('No top ids available');
    } else {
      _topIds.sink.add(topIds);
    }
  }

  /// Deletes all cached data.
  Future<void> clearCache() {
    return _repository.clearCaches();
  }

  dispose() {
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}
