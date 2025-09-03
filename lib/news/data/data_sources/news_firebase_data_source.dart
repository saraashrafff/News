import 'package:news/news/data/data_sources/news_data_source.dart';
import 'package:news/news/data/models/news.dart';

class NewsFirebaseDataSource implements NewsDataSource {
  @override
  Future<List<News>> getNews(String sourceId, {int page = 1}) async {
    //Firebase Logic
    return [];
  }
}
