import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:news_api_sample/Model/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class NewsScreenController with ChangeNotifier {
  List<Article> newsList = [];
  List<Article> searchList = [];
  bool issearckclicked = false;
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
  bool isLoading = false;

  Future<void> getArticles(String category) async {
    isLoading = true;
    newsList = []; // Clear the list
    notifyListeners();

    final url = category.isEmpty
        ? Uri.parse(
            "https://newsapi.org/v2/top-headlines?category=general&apiKey=03e73b84b8564c9eb235c55cc65a7595") // Default to general news
        : Uri.parse(
            "https://newsapi.org/v2/top-headlines?category=$category&apiKey=03e73b84b8564c9eb235c55cc65a7595"); // url for specific categrys

    // print( "$url");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Newsmodel modelobj = newsmodelFromJson(response.body);
        newsList = modelobj.articlelist ?? [];
      }
    } catch (e) {
      print("$e");
      newsList = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void onCategorySelection(int index) {
    selectedCategoryIndex = index;
    notifyListeners();

    if (index == 0) {
      getArticles(
          ''); // passing empty string to get general news for 'All' cetgry
    } else {
      getArticles(categoryList[index].toLowerCase());
    }
  }

  Future<void> ShareArticle(String? ArticleUrl) async {
    final result = await Share.share(ArticleUrl!);
    if (result.status == ShareResultStatus.success) {
      print("shared succuss");
    }
  }
clicksearch() {
    issearckclicked = !issearckclicked;
    notifyListeners();
  }
  Future<void> SearchNews({required String SearchKey}) async {
    final searchUrl = Uri.parse(
        'https://newsapi.org/v2/everything?q=$SearchKey&apiKey=48264279477343ca81a8cbb122807810');
    try {
      isLoading = true;
      notifyListeners();
      var response = await http.get(searchUrl);
      if (response.statusCode == 200) {
        Newsmodel newsmodel = newsmodelFromJson(response.body);
        searchList = newsmodel.articlelist ?? [];
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
