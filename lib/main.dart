import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screen/home.dart';
import 'screen/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final config = GoRouter(
      routes: [
        GoRoute(
          path: "/",
          name: 'home',
          builder: (_, _) => HomePage(),
          routes: [
            GoRoute(
              path: "/search",
              name: 'search',
              builder: (_, _) => SearchPage(),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: config,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
