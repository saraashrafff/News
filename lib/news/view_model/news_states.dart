import 'package:news/news/data/models/news.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class GetNewsLoading extends NewsState {}

class GetNewsMore extends NewsState {}

class GetNewsSuccess extends NewsState {
  final List<News> newsList;
  final bool hasMore;

  GetNewsSuccess({required this.newsList, required this.hasMore});
}

class GetNewsError extends NewsState {
  final String message;
  GetNewsError(this.message);
}
