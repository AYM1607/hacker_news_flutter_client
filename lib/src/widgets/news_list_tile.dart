import 'dart:async';

import 'package:flutter/material.dart';

import '../blocs/stories_provider.dart';
import '../models/item_model.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId});

  Widget build(BuildContext context) {
    StoriesBloc bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<ItemModel>>> cacheSnapshot) {
        if (!cacheSnapshot.hasData) {
          return Text('Stream loading');
        }

        return FutureBuilder(
          future: cacheSnapshot.data[itemId],
          builder:
              (BuildContext context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('Item loading');
            }

            return Text(itemSnapshot.data.title);
          },
        );
      },
    );
  }
}
