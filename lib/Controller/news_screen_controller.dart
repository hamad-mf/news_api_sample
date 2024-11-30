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


  void onCategorySelection(int index) {
    selectedCategoryIndex = index;
    notifyListeners();

    final category = index == 0 ? '' : categoryList[index].toLowerCase();
    getArticles(category);
  }

  
  Future<void> SearchNews({required String SearchKey}) async {
    
    final searchUrl = Uri.parse(
        "https://newsapi.org/v2/everything?q=$SearchKey&apiKey=48264279477343ca81a8cbb122807810");

    _setLoadingState(true);
    searchList = []; 
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
      print(e);
      searchList = [];
    }
    _setLoadingState(false);
  }

 
  Future<void> ShareArticle(String? ArticleUrl) async {
    if (ArticleUrl == null || ArticleUrl.isEmpty) {
      print("mo url found");
      return;
    }
    try {
      final result = await Share.share(ArticleUrl);
      if (result.status == ShareResultStatus.success) {
        print("Article shared successfully!");
      }
    } catch (e) {
      print( "$e");
    }
  }

 
  void clicksearch() {
    issearckclicked = false;
    searchList = [];
    notifyListeners();
  }


  void _setLoadingState(bool state) {
    isLoading = state;
    notifyListeners();
  }

 
  void _handleApiError(int statusCode) {
    print(" $statusCode");
    newsList = [];
    searchList = [];
  }
}
