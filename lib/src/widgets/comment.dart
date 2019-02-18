import 'dart:async';

import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../widgets/loading_tile.dart';

class Comment extends StatelessWidget {
  final int depth;
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;

  Comment({
    @required this.itemId,
    @required this.itemMap,
    @required this.depth,
  });

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingTile();
        }
        final item = snapshot.data;
        final children = <Widget>[
          ListTile(
            title: buildTileTitle(item),
            subtitle: item.by == '' ? Text('Deleted') : Text(item.by),
            contentPadding: EdgeInsets.only(
              left: (depth + 1) * 16.0,
              right: 16.0,
            ),
          ),
          Divider(),
        ];
        item.kids.forEach((kidId) {
          children.add(
            Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1,
            ),
          );
        });

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildTileTitle(ItemModel item) {
    final cleanText = item.text
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');

    return Text(cleanText);
  }
}
