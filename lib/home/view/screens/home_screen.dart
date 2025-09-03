import 'package:flutter/material.dart';
import 'package:news/categories/view/widgets/categories_view.dart';
import 'package:news/home/view/widgets/home_drawer.dart';
import 'package:news/categories/data/models/category_model.dart';
import 'package:news/news/view/widgets/news_view.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryModel? selectedCategory;
  bool isSearching = false;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "ابحث في الأخبار...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              )
            : Text(selectedCategory == null ? 'Home' : selectedCategory!.name),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  // رجوع للوضع العادي
                  isSearching = false;
                  searchQuery = "";
                } else {
                  // تفعيل البحث
                  isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      drawer: HomeDrawer(onGoToHomeClicked: resetSelectedCategory),
      body: selectedCategory == null
          ? CategoriesView(onCatergorySelected: onCatergorySelected)
          : NewsView(
              categoryId: selectedCategory!.id,
              searchQuery: searchQuery, // 🟢 نبعت الكلمة لصفحة الأخبار
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
    setState(() {});
  }
}
