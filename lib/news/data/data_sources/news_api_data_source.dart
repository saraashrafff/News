import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/news/data/data_sources/news_data_source.dart';
import 'package:news/news/data/models/news.dart';
import 'package:news/shared/api_constants.dart';
import 'package:news/news/data/models/news_response.dart';

class NewsAPIDataSource implements NewsDataSource {
  @override
  Future<List<News>> getNews(
    String sourceId, {
    int page = 1,
    String? query, // 🟢 إضافة باراميتر السيرش
  }) async {
    try {
      Uri uri = Uri.https(APIConstants.baseURL, APIConstants.newsEndPoint, {
        'apiKey': APIConstants.apiKey,
        'sources': sourceId,
        'page': page.toString(),
        'pageSize': '5',
        if (query != null && query.isNotEmpty) 'q': query, // 🟢 لو فيه كلمة بحث
      });

      http.Response response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load news, status code: ${response.statusCode}',
        );
      }

      Map<String, dynamic> json = jsonDecode(response.body);
      NewsResponse newsResponse = NewsResponse.fromJson(json);

      if (newsResponse.status != 'ok' || newsResponse.newsList == null) {
        throw Exception('Failed to load news: API returned error');
      }

      return newsResponse.newsList!;
    } catch (error) {
      throw Exception('Error fetching news: $error');
    }
  }
}
