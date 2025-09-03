import 'package:news/news/data/models/news.dart' show News;

abstract class NewsDataSource {
  Future<List<News>> getNews(String sourceId, {int page = 1});
}
