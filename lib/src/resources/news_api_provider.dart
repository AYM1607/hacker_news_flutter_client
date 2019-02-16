import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' show Client;

import 'repository.dart' show Source;
import '../models/item_model.dart';

const _rootUrl = 'https://hacker-news.firebaseio.com/v0';

/// An interface to the hacker news Api
class NewsApiProvider implements Source {
  Client client = Client();

  /// Returns a list of the current top ids
  Future<List<int>> fetchTopIds() async {
    try {
      final response = await client.get('$_rootUrl/topstories.json');
      final ids = json.decode(response.body);
      // The decoding proccess returns a list of dynamic elements, when integers
      // are expected, so we need to cast the list.
      return ids.cast<int>();
    } catch (e) {
      print('API: Error while fetching top ids');
      print('error text: ' + e.toString());
      return null;
    }
  }

  /// Returns an item from a particular id
  Future<ItemModel> fetchItem(int id) async {
    try {
      final response = await client.get('$_rootUrl/item/$id.json');
      final parsedJson = json.decode(response.body);

      return ItemModel.fromJson(parsedJson);
    } catch (e) {
      print('API: Error while fetching individual item');
      return null;
    }
  }
}
