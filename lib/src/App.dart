import "package:flutter/material.dart";

import "screens/news_list.dart";
import "blocs/stories_provider.dart";

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    // The whole application gets wrapped in a stories provider, so it can all
    // have acces to the stories bloc.
    return StoriesProvider(
      child: MaterialApp(
        title: 'Hacker News client',
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              return NewsList();
            },
          );
        },
      ),
    );
  }
}
