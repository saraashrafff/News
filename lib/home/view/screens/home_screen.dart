import 'package:flutter/material.dart';
import 'package:news/categories/view/widgets/categories_view.dart';
import 'package:news/home/view/widgets/home_drawer.dart';
import 'package:news/models/category_model.dart';
import 'package:news/news/view/widgets/news_view.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryModel? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory == null ? 'Home' : selectedCategory!.name),
      ),
      drawer: HomeDrawer(onGoToHomeClicked: resetSelectedCategory),
      body: selectedCategory == null
          ? CategoriesView(onCatergorySelected: onCatergorySelected)
          : NewsView(categoryId: selectedCategory!.id),
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
