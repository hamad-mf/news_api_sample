import 'package:flutter/material.dart';
import 'package:news_api_sample/Controller/news_screen_controller.dart';

import 'package:news_api_sample/View/News%20Screen/Widgets/news_card.dart';
import 'package:news_api_sample/View/Read%20News%20Screen/read_news_screen.dart';
import 'package:news_api_sample/View/Saved%20Articles/saved_articles.dart';
import 'package:news_api_sample/View/Search%20Screen/search_screen.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<Widget> screens = [
    NewsScreenContent(),
    SearchScreen(),
    SavedArticles(),
  ];

  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      context
          .read<NewsScreenController>()
          .onCategorySelection(0); // Select 'All' categroy by default
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NewsApp"),
      ),
      backgroundColor: Colors.white,
      body: screens[selectedTabIndex], //change the bdy
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            selectedTabIndex = value;
          });
        },
        currentIndex: selectedTabIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.amberAccent,
        unselectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_outlined),
            activeIcon: Icon(Icons.bookmark),
            label: "Saved",
          ),
        ],
      ),
    );
  }
}

class NewsScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsScreenController>(
      builder: (context, NewsScreenControlerobj, child) => Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                NewsScreenControlerobj.categoryList.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(12),
                  child: InkWell(
                    onTap: () {
                      NewsScreenControlerobj.onCategorySelection(index);
                    },
                    child: Container(
                      height: 45,
                      width: 130,
                      decoration: BoxDecoration(
                        color: NewsScreenControlerobj.selectedCategoryIndex ==
                                index
                            ? Colors.black
                            : Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        NewsScreenControlerobj.categoryList[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: NewsScreenControlerobj.selectedCategoryIndex ==
                                  index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: NewsScreenControlerobj.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final newsItem = NewsScreenControlerobj.newsList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReadNewsScreen(
                                          title: newsItem.title,
                                          ImgUrl: newsItem.urlToImage,
                                          content: newsItem.content,
                                          publishedAt: newsItem.publishedAt,
                                          author: newsItem.author,
                                          ArticleUrl: newsItem.url,
                                        )));
                          },
                          child: NewsCard(publishedAt: newsItem.publishedAt, author: newsItem.author,title: newsItem.title,imgurl: newsItem.urlToImage,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: NewsScreenControlerobj.newsList.length,
                  ),
          ),
        ],
      ),
    );
  }
}
