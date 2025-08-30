import 'package:flutter/material.dart';
import 'package:news/categories/view/widgets/categories_view.dart';
import 'package:news/home/view/widgets/home_drawer.dart';
import 'package:news/models/category_model.dart';
import 'package:news/news/data/models/news.dart';
import 'package:news/news/view/widgets/news_item.dart';
import 'package:news/news/view/widgets/news_view.dart';
import 'package:news/shared/app_theme.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryModel? selectedCategory;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  List<News> allNews = [];
  List<News> filteredNews = [];

  void filterNews(String query) {
    if (query.isEmpty) {
      filteredNews = List.from(allNews);
    } else {
      filteredNews = allNews.where((news) {
        final title = news.title?.toLowerCase() ?? '';
        final description = news.description?.toLowerCase() ?? '';
        final source = news.source?.name?.toLowerCase() ?? '';
        final searchKey = query.toLowerCase();

        return title.contains(searchKey) ||
            description.contains(searchKey) ||
            source.contains(searchKey);
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppTheme.black,
        title: !isSearching
            ? Text(selectedCategory == null ? 'Home' : selectedCategory!.name)
            : TextField(
                style: Theme.of(context).textTheme.titleSmall,
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search here...",
                  border: InputBorder.none,
                ),
                onChanged: filterNews,
              ),
        actions: [
          if (selectedCategory != null)
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    searchController.clear();
                    filteredNews = List.from(allNews);
                  }
                  isSearching = !isSearching;
                });
              },
            ),
        ],
      ),
      drawer: HomeDrawer(onGoToHomeClicked: resetSelectedCategory),
      body: selectedCategory == null
          ? CategoriesView(onCatergorySelected: onCatergorySelected)
          : isSearching
          ? filteredNews.isEmpty
                ? Center(
                    child: Text(
                      "No news found",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredNews.length,
                    itemBuilder: (_, index) =>
                        NewsItem(news: filteredNews[index]),
                  )
          : NewsView(
              categoryId: selectedCategory!.id,
              onNewsLoaded: (newsList) {
                allNews = newsList;
                filteredNews = List.from(newsList);
                setState(() {});
              },
            ),
    );
  }

  void onCatergorySelected(CategoryModel category) {
    selectedCategory = category;
    setState(() {});
  }

  void resetSelectedCategory() {
    if (selectedCategory == null) return;
    selectedCategory = null;
    allNews.clear();
    filteredNews.clear();
    searchController.clear();
    setState(() {});
  }
}
