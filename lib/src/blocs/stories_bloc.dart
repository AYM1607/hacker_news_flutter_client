import 'package:rxdart/rxdart.dart';

import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final Repository _repository = Repository();

  final PublishSubject _topIds = PublishSubject<List<int>>();

  // Streams getters
  Observable<List<int>> get topIds => _topIds.stream;

  /// Starts the process of fetching the top ids.
  ///
  /// They're made available through the [topIds] stream.
  /// These ids could be out of date if they come from a cached source.
  Future<void> fetchTopIds() async {
    final topIds = await _repository.fetchTopIds();
    _topIds.sink.add(topIds);
  }

  dispose() {
    _topIds.close();
  }
}
