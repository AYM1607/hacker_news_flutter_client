import 'package:flutter/material.dart';

import '../blocs/stories_provider.dart';

class TopIdsRefresher extends StatelessWidget {
  final Widget child;

  TopIdsRefresher({@required this.child});

  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.clearCache();
        await bloc.fetchTopIds();
      },
    );
  }
}
