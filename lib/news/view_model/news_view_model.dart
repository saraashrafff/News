import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/news/data/models/news.dart';
import 'package:news/news/data/repositories/news_repository.dart';
import 'package:news/news/view_model/news_states.dart';
import 'package:news/shared/service_locator.dart';

class NewsViewModel extends Cubit<NewsState> {
  late NewsRepository repository;
  NewsViewModel() : super(NewsInitial()) {
    repository = NewsRepository(ServiceLocator.newsDataSource);
  }

  Future<void> getNews(String sourceId, {int page = 1}) async {
    // لو أول صفحة -> نعرض Loading
    if (page == 1) {
      emit(GetNewsLoading());
    }

    try {
      // لو في أخبار موجودة قبل كده -> ناخد نسخة منها
      List<News> currentList = [];
      if (state is GetNewsSuccess) {
        currentList = List.from((state as GetNewsSuccess).newsList);
      }

      // API Request
      List<News> fetchedNews = await repository.getNews(sourceId, page: page);

      // ضيف الجديد على القديم
      currentList.addAll(fetchedNews);

      // لو اللي جالي أقل من 5 يبقى مفيش صفحات تاني
      bool hasMore = fetchedNews.length == 5;

      emit(GetNewsSuccess(newsList: currentList, hasMore: hasMore));
    } catch (error) {
      emit(GetNewsError(error.toString()));
    }
  }

  void clearNews() {
    emit(NewsInitial());
  }
}
