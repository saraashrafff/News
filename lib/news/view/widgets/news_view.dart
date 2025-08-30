import 'package:flutter/material.dart';
import 'package:news/shared/app_theme.dart';
import 'package:news/news/data/models/news.dart';
import 'package:news/news/view/widgets/news_item.dart';
import 'package:news/news/view_model/news_view_model.dart';
import 'package:news/sources/data/models/source.dart';
import 'package:news/sources/view/widgets/tab_item.dart';
import 'package:news/sources/view_model/sources_view_model.dart';
import 'package:news/shared/widgets/error_indicator.dart';
import 'package:news/shared/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class NewsView extends StatefulWidget {
  String categoryId;
  final Function(List<News>) onNewsLoaded;
  NewsView({required this.categoryId, required this.onNewsLoaded});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  int currentIndex = 0;
  int currentPage = 1;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();

  List<Source> sources = [];
  SourcesViewModel sourcesViewModel = SourcesViewModel();
  NewsViewModel newsViewModel = NewsViewModel();

  @override
  void initState() {
    super.initState();

    // Scroll listener لتحميل الصفحات الجديدة
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !newsViewModel.isLoading &&
          hasMore) {
        loadMore();
      }
    });
  }

  void loadMore() {
    if (sources.isEmpty) return;

    String sourceId = sources[currentIndex].id!;
    print("⬇️ Loading page $currentPage for source $sourceId");

    newsViewModel.getNews(sourceId, page: currentPage).then((fetchedNews) {
      print(
        "✅ Page $currentPage loaded, fetched ${fetchedNews.length} news items",
      );

      if (fetchedNews.length < 5) {
        hasMore = false;
        print("⚠️ No more news available for this source.");
      } else {
        currentPage++;
      }
      widget.onNewsLoaded(newsViewModel.newsList);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sourcesViewModel..getSources(widget.categoryId),
      child: Consumer<SourcesViewModel>(
        builder: (_, viewModel, __) {
          if (viewModel.isLoading) {
            return LoadingIndicator();
          } else if (viewModel.errorMessage != null) {
            return ErrorIndicator(viewModel.errorMessage!);
          } else {
            sources = viewModel.sources;

            // fetch أول صفحة من الأخبار لأول source
            if (newsViewModel.newsList.isEmpty && sources.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                loadMore();
              });
            }

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
                      currentPage = 1;
                      hasMore = true;
                      newsViewModel.clearNews();
                      loadMore();
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: ChangeNotifierProvider.value(
                    value: newsViewModel,
                    child: Consumer<NewsViewModel>(
                      builder: (_, viewModel, __) {
                        if (viewModel.isLoading && viewModel.newsList.isEmpty) {
                          return LoadingIndicator();
                        } else if (viewModel.errorMessage != null) {
                          return ErrorIndicator(viewModel.errorMessage!);
                        } else {
                          List<News> newsList = viewModel.newsList;
                          return ListView.separated(
                            controller: _scrollController,
                            padding: EdgeInsets.only(
                              top: 16,
                              left: 16,
                              right: 16,
                            ),
                            itemBuilder: (_, index) {
                              if (index < newsList.length) {
                                return NewsItem(news: newsList[index]);
                              } else {
                                return Center(
                                  child: hasMore
                                      ? Padding(
                                          padding: EdgeInsets.all(16),
                                          child: LoadingIndicator(),
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
                            itemCount: newsList.length + 1,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
