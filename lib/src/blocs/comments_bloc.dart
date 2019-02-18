import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/item_model.dart';
import '../resources/repository.dart';

/// A business logic component that is in charge of fetching and keeping track
/// of a specific storie and all of its comments.
class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  // Streams getters
  /// A cache map that stores all the fetched items.
  Observable<Map<int, Future<ItemModel>>> get itemWitComments =>
      _commentsOutput.stream;

  // Sinks getters
  /// Starts the process of fetching an item and all of its descendants.
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  /// Transforms and id into future of [ItemModel].
  ///
  /// This transformer recursively fetches all the kids of the current item when
  /// its future resolves.
  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int itemId, int index) {
        cache[itemId] = _repository.fetchItem(itemId);
        cache[itemId].then((ItemModel item) {
          item.kids.forEach((kidId) {
            fetchItemWithComments(kidId);
          });
        });
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
