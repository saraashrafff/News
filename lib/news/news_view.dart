import 'package:flutter/material.dart';
import 'package:news/api/api_service.dart';
import 'package:news/app_theme.dart';
import 'package:news/models/news_response/news.dart';
import 'package:news/models/sources_response/source.dart';
import 'package:news/models/sources_response/sources_response.dart';
import 'package:news/news/news_item.dart';
import 'package:news/news/tab_item.dart';
import 'package:news/widgets/error_indicator.dart';
import 'package:news/widgets/loading_indicator.dart';

class NewsView extends StatefulWidget {
  String categoryId;

  NewsView({required this.categoryId});
  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  late Future<SourcesResponse> getSourcesFuture = APIService.getSources(
    widget.categoryId,
  );
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSourcesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        } else if (snapshot.hasError) {
          return ErrorIndicator();
        } else {
          List<Source> sources = snapshot.data?.sources ?? [];
          return Column(
            children: [
              DefaultTabController(
                length: sources.length,
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: AppTheme.white,
                  tabAlignment: TabAlignment.start,
                  labelPadding: EdgeInsetsDirectional.only(start: 16),
                  isScrollable: true,
                  tabs: sources
                      .map(
                        (source) => TabItem(
                          source: source,
                          isSelected: currentIndex == sources.indexOf(source),
                        ),
                      )
                      .toList(),
                  onTap: (index) {
                    if (currentIndex == index) return;
                    currentIndex = index;
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: APIService.getNews(sources[currentIndex].id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingIndicator();
                    } else if (snapshot.hasError ||
                        snapshot.data?.status != 'ok') {
                      return ErrorIndicator();
                    } else {
                      List<News> newsList = snapshot.data?.newsList ?? [];
                      return ListView.separated(
                        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                        itemBuilder: (_, index) =>
                            NewsItem(news: newsList[index]),
                        separatorBuilder: (_, _) => SizedBox(height: 16),
                        itemCount: newsList.length,
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
