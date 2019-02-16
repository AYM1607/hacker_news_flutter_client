import 'package:flutter/material.dart';

import 'stories_bloc.dart';
export 'stories_bloc.dart';

/// Provider that allows the use of the stories bloc on a particular
/// widget subtree.
class StoriesProvider extends InheritedWidget {
  /// An instance of a stories bloc.
  final StoriesBloc _bloc;

  StoriesProvider({Key key, Widget child})
      : _bloc = StoriesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  /// Returns a stories bloc from a context.
  static StoriesBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(StoriesProvider)
            as StoriesProvider)
        ._bloc;
  }
}
