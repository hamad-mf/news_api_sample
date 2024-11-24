import 'package:flutter/material.dart';
import 'package:news_api_sample/Controller/news_screen_controller.dart';

import 'package:news_api_sample/View/News%20Screen/news_screen.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> NewsScreenController(),)
      ],
      
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: NewsScreen(),
      ));
  }
}
