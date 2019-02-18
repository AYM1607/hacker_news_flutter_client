import "package:flutter/material.dart";

import "blocs/stories_provider.dart";
import "screens/news_list.dart";
import "screens/news_detail.dart";

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    // The whole application gets wrapped in a stories provider, so it can all
    // have acces to the stories bloc.
    return StoriesProvider(
      child: MaterialApp(
        title: 'Hacker News client',
        onGenerateRoute: routes,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (BuildContext context) {
        return NewsList();
      });
    }
    return MaterialPageRoute(
      builder: (BuildContext context) {
        // Parsing the item id from the route.
        final itemId = int.parse(
          settings.name.replaceFirst('/', ''),
        );
        return NewsDetail(
          itemId: itemId,
        );
      },
    );
  }
}
