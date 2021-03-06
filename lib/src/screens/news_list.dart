import "package:flutter/material.dart";

import "../blocs/stories_provider.dart";
import "../widgets/news_list_tile.dart";
import "../widgets/top_ids_refresher.dart";

class NewsList extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Top news'),
      ),
      body: getList(bloc),
    );
  }

  Widget getList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (snapshot.hasError) {
          return TopIdsRefresher(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Center(
                    child: Text('Error while fetching the top stories'),
                  ),
                ),
              ],
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return TopIdsRefresher(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              bloc.fetchItem(snapshot.data[index]);

              return NewsListTile(
                itemId: snapshot.data[index],
              );
            },
          ),
        );
      },
    );
  }
}
