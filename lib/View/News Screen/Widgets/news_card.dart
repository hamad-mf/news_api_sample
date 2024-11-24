import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

// ignore: must_be_immutable
class NewsCard extends StatelessWidget {
  String? imgurl;
  String? title;
  String? author;
  DateTime? publishedAt;
  String? id;
  NewsCard({
    super.key,
    required this.author,
    required this.publishedAt,
    required this.imgurl,
    required this.title,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? 'No Title',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (imgurl != null)
            SizedBox(
              height: 200,
              width: 345,
              child: Image.network(
                imgurl!,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Author:"),
              Text(author ?? "not specified"),
              Text("Published At"),
            ],
          ),
          if (publishedAt != null)
            Text(
              DateFormat('dd MMM yyyy, hh:mm a').format(publishedAt!),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
