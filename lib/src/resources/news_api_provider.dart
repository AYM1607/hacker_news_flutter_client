import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' show Client;

import '../models/item_model.dart';

const _rootUrl = 'https://hacker-news.firebaseio.com/v0';

/// An interface to the hacker news Api
class NewsApiProvider {
  Client client = Client();

  /// Returns a list of the current top ids
  fetchTopIds() async {
    try {
      final response = await client.get('$_rootUrl/topstories.json');
      final ids = json.decode(response.body);

      return ids;
    } catch (e) {
      print('API: Error while fetching top ids');
      return null;
    }
  }

  /// Returns an item from a particular id
  fetchItem(int id) async {
    try {
      final response = await client.get('$_rootUrl/stories/$id.json');
      final parsedJson = json.decode(response.body);

      return ItemModel.fromJson(parsedJson);
    } catch (e) {
      print('API: Error while fetching individual item');
      return null;
    }
  }
}
