import 'dart:async';

import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../widgets/loading_tile.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;

  Comment({@required this.itemId, @required this.itemMap});

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingTile();
        }

        return Text(snapshot.data.text);
      },
    );
  }
}
