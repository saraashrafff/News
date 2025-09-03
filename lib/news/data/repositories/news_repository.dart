import 'package:news/news/data/data_sources/news_data_source.dart';
import 'package:news/news/data/models/news.dart';

class NewsRepository {
  NewsDataSource dataSource;
  NewsRepository(this.dataSource);

  Future<List<News>> getNews(String sourceId, {int page = 1}) {
    return dataSource.getNews(sourceId, page: page);
  }
}
