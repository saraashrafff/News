import 'package:flutter/widgets.dart';
import 'package:news/news/data/data_sources/news_data_source.dart';
import 'package:news/news/data/models/news.dart';
import 'package:news/news/data/models/news_response.dart';

class NewsViewModel with ChangeNotifier {
  NewsDataSource dataSource = NewsDataSource();
  bool isLoading = false;
  List<News> newsList = [];
  String? errorMessage; // صححت الاسم

  Future<List<News>> getNews(String sourceId, {int page = 1}) async {
    isLoading = true;
    errorMessage = null; // إعادة تعيين الرسالة القديمة
    notifyListeners();

    try {
      NewsResponse response = await dataSource.getNews(sourceId, page: page);
      if (response.status == 'ok' && response.newsList != null) {
        if (page == 1) {
          newsList = response.newsList!;
        } else {
          newsList.addAll(response.newsList!);
        }
        return response.newsList!;
      } else {
        errorMessage = 'Failed to load news';
        return [];
      }
    } catch (error) {
      errorMessage = error.toString();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearNews() {
    newsList.clear();
    notifyListeners();
  }
}
