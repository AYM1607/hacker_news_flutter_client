import "package:flutter/material.dart";

import 'blocs/comments_provider.dart';
import "blocs/stories_provider.dart";
import "screens/news_list.dart";
import "screens/news_detail.dart";

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    // The whole application gets wrapped in a stories provider, so it can all
    // have acces to the stories bloc.
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'Hacker News client',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (BuildContext context) {
        final storiesBloc = StoriesProvider.of(context);

        storiesBloc.fetchTopIds();

        return NewsList();
      });
    }
    return MaterialPageRoute(
      builder: (BuildContext context) {
        final commentsBloc = CommentsProvider.of(context);
        // Parsing the item id from the route.
        final itemId = int.parse(
          settings.name.replaceFirst('/', ''),
        );

        // Initiate the fetching process for the item that corresponds to this
        // screen.
        commentsBloc.fetchItemWithComments(itemId);

        return NewsDetail(
          itemId: itemId,
        );
      },
    );
  }
}
