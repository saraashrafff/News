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

  List<News> newsList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    getSourcesFuture.then((sourcesResponse) {
      sources = sourcesResponse.sources ?? [];
      if (sources.isNotEmpty) {
        loadNews(); // أول ما أجيب sources أجيب أول news
      }
    });

    // Listen for scroll end
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Near bottom -> load next page
        loadNews();
      }
    });
  }

  void loadNews() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      var sourceId = sources[currentIndex].id!;
      var newsResponse = await APIService.getNews(sourceId, page: currentPage);
      print("Page $currentPage → ${newsResponse.newsList?.length}");

      setState(() {
        newsList.addAll(newsResponse.newsList ?? []);
        currentPage++;
        if ((newsResponse.newsList?.length ?? 0) < 5) {
          hasMore = false; // no more data
        }
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<Source> sources = [];

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
          sources = snapshot.data?.sources ?? [];
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
                    // reset pagination
                    newsList.clear();
                    currentPage = 1;
                    hasMore = true;
                    loadNews();
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  itemBuilder: (_, index) {
                    if (index < newsList.length) {
                      return NewsItem(news: newsList[index]);
                    } else {
                      // show loader at the end
                      return Center(
                        child: hasMore
                            ? Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: LoadingIndicator()),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                ),
                                child: Text(
                                  "No more news",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                      );
                    }
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 16),
                  itemCount: newsList.length + 1, // +1 for loader
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
