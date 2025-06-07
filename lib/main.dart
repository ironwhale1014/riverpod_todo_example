import 'package:drift_todo_train/screen/home_page.dart';
import 'package:drift_todo_train/screen/search_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
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
