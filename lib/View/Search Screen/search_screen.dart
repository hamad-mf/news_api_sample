import 'package:flutter/material.dart';
import 'package:news_api_sample/Controller/news_screen_controller.dart';
import 'package:news_api_sample/View/News%20Screen/Widgets/news_card.dart';
import 'package:news_api_sample/View/Read%20News%20Screen/read_news_screen.dart';
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
  void initState() {
    super.initState();
    final provider = context.read<NewsScreenController>();
    provider.clicksearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                          context.read<NewsScreenController>().SearchNews(
                              SearchKey: searchController.text.toString());
                          searchController.clear();
                        }
                      },
                      icon: Icon(Icons.search, color: Colors.white),
                    ),
                    hintText: 'Search news...',
                    hintStyle: TextStyle(color: Colors.white70),
                    fillColor: Colors.grey.withOpacity(0.6),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildNewsListSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsListSection() {
    return Consumer<NewsScreenController>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          // Show loading indicator while fetching results
          return const Center(child: CircularProgressIndicator());
        }

        if (!provider.issearckclicked) {
          // No search has been performed yet
          return _buildNoResultsFound();
        }

        if (provider.searchList.isEmpty) {
          // Search performed but no results found
          return _buildNoResultsFound();
        }

        // Display search results
        final articles = provider.searchList;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: articles.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) => InkWell(
              child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ReadNewsScreen(title: articles[index].title,
                                          ImgUrl: articles[index].urlToImage,
                                          content: articles[index].content,
                                          publishedAt: articles[index].publishedAt,
                                          author: articles[index].author)));
            },
            child: NewsCard(
              publishedAt: articles[index].publishedAt,
              imgurl: articles[index].urlToImage ?? '',
              title: articles[index].title ?? '',
              author: articles[index].author ?? '',
            ),
          )),
        );
      },
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
