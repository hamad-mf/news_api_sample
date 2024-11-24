import 'package:flutter/material.dart';
import 'package:news_api_sample/Controller/news_screen_controller.dart';
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
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<NewsScreenController>().onCategorySelection(0); // Select 'All'
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      backgroundColor: Colors.white,
      body: screens[selectedTabIndex], // Dynamically update the body
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
            icon: Icon(Icons.exit_to_app_outlined),
            activeIcon: Icon(Icons.exit_to_app),
            label: "Logout",
          ),
        ],
      ),
    );
  }
}

// Refactor the main news content to a separate widget
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
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 25),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newsItem.title ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (newsItem.urlToImage != null)
                              SizedBox(
                                height: 200,
                                width: 300,
                                child: Image.network(
                                  newsItem.urlToImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(height: 10),
                          ],
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
