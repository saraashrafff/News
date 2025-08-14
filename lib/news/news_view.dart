import 'package:flutter/material.dart';
import 'package:news/app_theme.dart';
import 'package:news/models/source_model.dart';
import 'package:news/news/news_item.dart';
import 'package:news/news/tab_item.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  int currentIndex = 0;
  List<SourceModel> sources = List.generate(
    10,
    (index) => SourceModel(id: '$index', name: 'Source $index'),
  );
  @override
  Widget build(BuildContext context) {
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
          child: ListView.separated(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            itemBuilder: (_, index) => NewsItem(),
            separatorBuilder: (_, _) => SizedBox(height: 16),
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
