import 'package:flutter/material.dart';
import 'package:news_api_sample/Controller/news_screen_controller.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      
      Form(
        key: _formKey,
        child: TextFormField(
          controller: searchController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          textAlign: TextAlign.left,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  context
                      .read<NewsScreenController>()
                      .SearchNews(SearchKey: searchController.text);
                  searchController.clear();
                }
              },
              icon: Icon(Icons.search, color: Colors.white),
            ),
            fillColor: Colors.grey.withOpacity(0.6),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
