import 'package:flutter/material.dart';
import 'package:news_api_sample/Model/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class NewsScreenController with ChangeNotifier {
  List<Article> newsList = [];
  List<Article> searchList = [];
  bool issearckclicked = false;
  bool isLoading = false;

  List<String> categoryList = [
    'All',
    'Business',
    'Sports',
    'Health',
    'Entertainment',
    'Science',
    'Technology',
  ];
  int selectedCategoryIndex = 0;

  // Fetch articles by category
  Future<void> getArticles(String category) async {
    _setLoadingState(true);
    newsList = []; // Clear previous articles
    notifyListeners();

    final url = category.isEmpty
        ? Uri.parse(
            "https://newsapi.org/v2/top-headlines?category=general&apiKey=03e73b84b8564c9eb235c55cc65a7595")
        : Uri.parse(
            "https://newsapi.org/v2/top-headlines?category=$category&apiKey=03e73b84b8564c9eb235c55cc65a7595");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Newsmodel modelobj = newsmodelFromJson(response.body);
        newsList = modelobj.articlelist ?? [];
      } else {
        _handleApiError(response.statusCode);
      }
    } catch (e) {
      print("Error fetching articles: $e");
      newsList = [];
    }
    _setLoadingState(false);
  }

  // Handle category selection
  void onCategorySelection(int index) {
    selectedCategoryIndex = index;
    notifyListeners();

    final category = index == 0 ? '' : categoryList[index].toLowerCase();
    getArticles(category);
  }

  // Search articles by keyword
  Future<void> SearchNews({required String SearchKey}) async {
    print("Search initiated with keyword: $SearchKey");
    final searchUrl = Uri.parse(
        "https://newsapi.org/v2/everything?q=$SearchKey&apiKey=48264279477343ca81a8cbb122807810");

    _setLoadingState(true);
    searchList = []; // Clear previous search results
    notifyListeners();

    try {
      final response = await http.get(searchUrl);
      if (response.statusCode == 200) {
        final Newsmodel newsmodel = newsmodelFromJson(response.body);
        searchList = newsmodel.articlelist ?? [];
        issearckclicked = true;
      } else {
        _handleApiError(response.statusCode);
      }
    } catch (e) {
      print("Error during search: $e");
      searchList = [];
    }
    _setLoadingState(false);
  }

  // Handle sharing of articles
  Future<void> ShareArticle(String? ArticleUrl) async {
    if (ArticleUrl == null || ArticleUrl.isEmpty) {
      print("Invalid article URL for sharing.");
      return;
    }
    try {
      final result = await Share.share(ArticleUrl);
      if (result.status == ShareResultStatus.success) {
        print("Article shared successfully!");
      }
    } catch (e) {
      print("Error sharing article: $e");
    }
  }

  // Reset search state
  void clicksearch() {
    issearckclicked = false;
    searchList = [];
    notifyListeners();
  }

  // Helper to set loading state
  void _setLoadingState(bool state) {
    isLoading = state;
    notifyListeners();
  }

  // Handle API errors
  void _handleApiError(int statusCode) {
    print("API Error: Status Code $statusCode");
    newsList = [];
    searchList = [];
  }
}
