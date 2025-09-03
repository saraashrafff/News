import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/news/view_model/news_states.dart';
import 'package:news/shared/app_theme.dart';
import 'package:news/news/data/models/news.dart';
import 'package:news/news/view/widgets/news_item.dart';
import 'package:news/news/view_model/news_view_model.dart';
import 'package:news/sources/data/models/source.dart';
import 'package:news/sources/view/widgets/tab_item.dart';
import 'package:news/sources/view_model/sources_states.dart';
import 'package:news/sources/view_model/sources_view_model.dart';
import 'package:news/shared/widgets/error_indicator.dart';
import 'package:news/shared/widgets/loading_indicator.dart';

class NewsView extends StatefulWidget {
  String categoryId;
  final String searchQuery;
  final Function(List<News>)? onNewsLoaded;

  NewsView({
    required this.categoryId,
    this.searchQuery = '',
    this.onNewsLoaded,
  });
  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  int currentIndex = 0;
  int currentPage = 1;
  bool isLoadingMore = false;

  final ScrollController _scrollController = ScrollController();

  List<Source> sources = [];
  SourcesViewModel sourcesViewModel = SourcesViewModel();
  NewsViewModel newsViewModel = NewsViewModel();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final currentState = newsViewModel.state;
        if (currentState is GetNewsSuccess && currentState.hasMore) {
          loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    newsViewModel.close();

    super.dispose();
  }

  void loadMore() async {
    if (sources.isEmpty || isLoadingMore) return;

    isLoadingMore = true;
    String sourceId = sources[currentIndex].id!;
    print("⬇️ Loading page $currentPage for source $sourceId");

    await newsViewModel.getNews(sourceId, page: currentPage);
    currentPage++;
    isLoadingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sourcesViewModel..getSources(widget.categoryId),
      child: BlocBuilder<SourcesViewModel, SourcesState>(
        builder: (ctx, state) {
          BlocProvider.of<SourcesViewModel>(ctx);
          if (state is GetSourcesLoading) {
            return LoadingIndicator();
          } else if (state is GetSourcesError) {
            return ErrorIndicator(state.messege);
          } else if (state is GetSourcesSuccess) {
            sources = state.sources;
            if (sources.isNotEmpty && newsViewModel.state is NewsInitial) {
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
                    onTap: (index) async {
                      if (currentIndex == index) return;

                      currentIndex = index;
                      currentPage = 1;
                      isLoadingMore = false;
                      newsViewModel.clearNews();

                      await newsViewModel.getNews(
                        sources[currentIndex].id!,
                        page: currentPage,
                      );
                      currentPage++;
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: BlocProvider.value(
                    value: newsViewModel,
                    child: BlocBuilder<NewsViewModel, NewsState>(
                      builder: (context, state) {
                        if (state is GetNewsLoading) {
                          return LoadingIndicator();
                        } else if (state is GetNewsError) {
                          return ErrorIndicator();
                        } else if (state is GetNewsSuccess) {
                          List<News> newsList = state.newsList;
                          if (widget.onNewsLoaded != null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              widget.onNewsLoaded!(newsList);
                            });
                          }

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
                                  child: state.hasMore
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
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
