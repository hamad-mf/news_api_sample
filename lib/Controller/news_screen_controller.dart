import 'package:flutter/material.dart';
import 'package:news_api_sample/Model/news_model.dart';
import 'package:http/http.dart' as http;

class NewsScreenController with ChangeNotifier {
  List<Article> newsList = [];
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

  // Construct the API URL
  final url = category.isEmpty
      ? Uri.parse(
          "https://newsapi.org/v2/top-headlines?country=us&apiKey=03e73b84b8564c9eb235c55cc65a7595") // Default to US news
      : Uri.parse(
          "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=03e73b84b8564c9eb235c55cc65a7595"); // Filter by category

  print("Fetching articles for URL: $url");

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Newsmodel modelobj = newsmodelFromJson(response.body);
      newsList = modelobj.articlelist ?? [];
      print("Fetched ${newsList.length} articles for category: $category");
    } else {
      print("Failed to fetch articles. Status code: ${response.statusCode}");
      newsList = [];
    }
  } catch (e) {
    print("Error fetching articles: $e");
    newsList = [];
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

  void onCategorySelection(int index) {
  selectedCategoryIndex = index;
  notifyListeners();

  
  if (index == 0) {
   
    getArticles('');
  } else {
    
    getArticles(categoryList[index].toLowerCase());
  }
}
}
