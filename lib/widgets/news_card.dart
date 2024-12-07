import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../views/news_detail_screen.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;

  NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(article.urlToImage, fit: BoxFit.cover, width: 100),
        title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(article.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)),
          );
        },
      ),
    );
  }
}
