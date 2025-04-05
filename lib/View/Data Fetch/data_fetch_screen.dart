import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news_api_sample/Controller/jobs_screen_controller.dart';
import 'package:news_api_sample/Model/all_jobs_listing_model.dart';
import 'package:provider/provider.dart';

class DataFetchScreen extends StatefulWidget {
  const DataFetchScreen({super.key});

  @override
  State<DataFetchScreen> createState() => _DataFetchScreenState();
}

class _DataFetchScreenState extends State<DataFetchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobsScreenController>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: Consumer<JobsScreenController>(
        builder: (context, controller, child) {
          if (controller.isloading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.categoriesList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No categories available"),
                  ElevatedButton(
                    onPressed: () => controller.getCategories(),
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final cate = controller.categoriesList[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cate.title ?? "No title",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: controller.categoriesList.length,
          );
        },
      ),
    );
  }
}
