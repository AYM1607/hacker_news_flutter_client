import 'package:flutter/material.dart';

import '../blocs/comments_provider.dart';
import '../models/item_model.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({this.itemId});

  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('News detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWitComments,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          // At this point, no item has started the fetching process.
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // At this point, the future corresponding to the top level item
        // is already in the cache map.
        final itemFuture = snapshot.data[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder:
              (BuildContext context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              // The fetching process for the top level item hasnt finished.
              return Text('loading');
            }
            return buildList(itemSnapshot.data, snapshot.data);
          },
        );
      },
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    final comments = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
      );
    }).toList();

    children.add(buildTitle(item.title));
    children.addAll(comments);

    return ListView(
      children: children,
    );
  }

  Widget buildTitle(String title) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
