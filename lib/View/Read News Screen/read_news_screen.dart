import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_api_sample/Controller/news_screen_controller.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ReadNewsScreen extends StatefulWidget {
  String? title;
  String? ImgUrl;
  String? content;
  String? author;
  DateTime? publishedAt;
  String? ArticleUrl;
  ReadNewsScreen(
      {super.key,
      this.content,
      this.ArticleUrl,
      this.publishedAt,
      this.author,
      this.ImgUrl,
      this.title});

  @override
  State<ReadNewsScreen> createState() => _ReadNewsScreenState();
}

class _ReadNewsScreenState extends State<ReadNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.ImgUrl != null)
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.network(
                        widget.ImgUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.content!,
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Author: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        TextSpan(
                          text: widget.author ?? 'Not specified',
                          style: TextStyle(color: Colors.black, fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Published At: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        if (widget.publishedAt != null)
                          TextSpan(
                            text: DateFormat('dd MMM yyyy, hh:mm a')
                                .format(widget.publishedAt!),
                            style: TextStyle(color: Colors.black, fontSize: 19),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Row(
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(170, 50)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Save",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.bookmark_border_outlined)
                    ],
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const HomeScreen()));
                  }),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(170, 50)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Share",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.share)
                    ],
                  ),
                  onPressed: () {
                    context
                        .read<NewsScreenController>()
                        .ShareArticle(widget.ArticleUrl);
                  }),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
