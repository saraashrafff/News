import 'package:news/news/data/data_sources/news_api_data_source.dart';
import 'package:news/news/data/data_sources/news_data_source.dart';
import 'package:news/sources/data/data_sources/sources_api_data_source.dart';
import 'package:news/sources/data/data_sources/sources_data_source.dart';
// import 'package:news/news/data/repositories/news_repository.dart';

class ServiceLocator {
  static NewsDataSource newsDataSource = NewsAPIDataSource();
  // static NewsRepository newsRepository = NewsRepository(newsDataSource);
  static SourcesDataSource sourcesDataSource = SourcesAPIDataSource();
}
