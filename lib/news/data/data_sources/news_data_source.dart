import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/shared/api_constants.dart';
import 'package:news/news/data/models/news_response.dart';

class NewsDataSource {
  Future<NewsResponse> getNews(String sourceId, {int page = 1}) async {
    Uri uri = Uri.https(APIConstants.baseURL, APIConstants.newsEndPoint, {
      'apiKey': APIConstants.apiKey,
      'sources': sourceId,
      'page': page.toString(), // <-- simple pagination
      'pageSize': '5', // <-- 5 items per page
    });
    print("🌐 Fetching URL: $uri");


    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
    print("📥 Response body: ${response.body}");

      Map<String, dynamic> json = jsonDecode(response.body);
      return NewsResponse.fromJson(json);
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
