import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/news_article.dart';

class NewsService {
  final String _baseUrl = 'https://newsapi.org/v2';
  final String _apiKey = '8169ed959151474fb42c664464676e3f';

  Future<List<NewsArticle>> fetchNews(String category) async {
    final url = Uri.parse('$_baseUrl/top-headlines?category=$category&country=us&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['articles'] as List).map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
