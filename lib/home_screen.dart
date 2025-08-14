import 'package:flutter/material.dart';
import 'package:news/categories/categories_view.dart';
import 'package:news/news/news_view.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: NewsView(),
    );
  }
}
