import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (_, _) => HomePage(),
          routes: [
            GoRoute(
              path: '/search',
              name: 'search',
              builder: (_, __) => SearchPage(),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: config,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
