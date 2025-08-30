import 'package:flutter/material.dart';
import 'package:news/shared/app_theme.dart';
import 'package:news/news/data/models/news.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsItem extends StatelessWidget {
  News news;
  NewsItem({required this.news});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.white),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              news.urlToImage ??
                  'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
              height: MediaQuery.sizeOf(context).height * 0.25,
              width: double.infinity,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                  height: MediaQuery.sizeOf(context).height * 0.25,
                  width: double.infinity,
                  fit: BoxFit.fill,
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Text(news.title!, style: textTheme.titleMedium),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'By : ${news.author ?? news.source!.name}',
                  style: textTheme.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                timeago.format(news.publishedAt!),
                style: textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
