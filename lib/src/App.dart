import "package:flutter/material.dart";
import "screens/news_list.dart";

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News client',
      home: NewsList(),
    );
  }
}
