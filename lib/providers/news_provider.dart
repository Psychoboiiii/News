import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  List<dynamic> _articles = [];

  List<dynamic> get articles => _articles;

  Future<void> fetchNews() async {
    const String apiKey = '8169ed959151474fb42c664464676e3f';
    const String url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = data['articles'] ?? [];
        print(url);
        notifyListeners();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
