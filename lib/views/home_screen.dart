import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/sort_menu.dart';
import '../widgets/category_tabs.dart';
import '../widgets/CustomSearchBar.dart';
import '../widgets/news_card.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchNewsFuture;
  List<NewsArticle> _displayedArticles = [];
  List<NewsArticle> _allArticles = [];
  String _searchQuery = '';
  String _selectedCategory = 'Technology';

  // List of sort options
  final List<String> sortOptions = ['Newest', 'Oldest', 'Relevance'];
  final NewsService _newsService = NewsService();

  @override
  void initState() {
    super.initState();
    _fetchNewsFuture = _initializeArticles();
  }

  Future<void> _initializeArticles() async {
    try {
      setState(() {
        _displayedArticles = [];
      });

      final articles = await _newsService.fetchNews(_selectedCategory);

      setState(() {
        _allArticles = articles;
        _displayedArticles = List.from(_allArticles);
      });
    } catch (e) {
      print('Error fetching news: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load news. Please try again.')),
      );
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _initializeArticles();
  }

  void _onSortSelected(String sortOption) {
    setState(() {
      if (sortOption == 'Newest') {
        _displayedArticles.sort((a, b) {

          return b.title.compareTo(a.title); // Placeholder sorting
        });
      } else if (sortOption == 'Oldest') {
        _displayedArticles.sort((a, b) {
          return a.title.compareTo(b.title); // Placeholder sorting
        });
      }
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _displayedArticles = _allArticles.where((article) =>
      article.title.toLowerCase().contains(_searchQuery) ||
          article.description.toLowerCase().contains(_searchQuery)
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        actions: [
          SortMenu(
            sortOptions: sortOptions,
            onSortSelected: _onSortSelected,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          CategoryTab(
            onCategorySelected: _onCategorySelected,
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomSearchBar(
              hintText: 'Search news...',
              onSearch: _onSearch,
            ),
          ),

          // News Articles List
          Expanded(
            child: _buildNewsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return FutureBuilder(
      future: _fetchNewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to load news'),
                ElevatedButton(
                  onPressed: _initializeArticles,
                  child: Text('Retry'),
                )
              ],
            ),
          );
        } else if (_displayedArticles.isEmpty) {
          return Center(child: Text('No articles found.'));
        } else {
          return ListView.builder(
            itemCount: _displayedArticles.length,
            itemBuilder: (context, index) {
              return NewsCard(article: _displayedArticles[index]);
            },
          );
        }
      },
    );
  }
}