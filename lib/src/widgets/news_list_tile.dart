import 'dart:async';

import 'package:flutter/material.dart';

import '../blocs/stories_provider.dart';
import '../models/item_model.dart';
import '../widgets/loading_tile.dart';

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
          return LoadingTile();
        }

        return FutureBuilder(
          future: cacheSnapshot.data[itemId],
          builder:
              (BuildContext context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingTile();
            }

            return getTile(itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget getTile(ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(item.title),
          subtitle: Text('${item.score} points'),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.mode_comment),
              Text('${item.descendants}'),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
