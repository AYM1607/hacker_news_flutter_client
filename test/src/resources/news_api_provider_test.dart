import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hacker_news_flutter_client/src/resources/news_api_provider.dart';

void main() {
  group("News Api provider: ", () {
    test('fetchTopIds returns a list of ids', () async {
      // Setup
      final newsApi = NewsApiProvider();
      newsApi.client = MockClient((Request request) async {
        return Response(json.encode([1, 2, 3]), 200);
      });
      final topIds = await newsApi.fetchTopIds();

      // Expectation
      expect(topIds, [1, 2, 3]);
    });

    test('fetchItem returns an ItemModel', () async {
      // Setup
      final newsApi = NewsApiProvider();
      newsApi.client = MockClient((Request request) async {
        final jsonMap = {
          'id': 1251,
          'dead': false,
          'text': "test",
        };
        return Response(json.encode(jsonMap), 200);
      });

      final item = await newsApi.fetchItem(123);
      // Expectation
      expect(item.id, 1251);
      expect(item.dead, false);
      expect(item.text, "test");
    });
  });
}
