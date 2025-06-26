import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'screen/home_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final config = GoRouter(
    routes: [GoRoute(path: '/', name: 'home', builder: (_, _) => HomePage())],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: config,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
    );
  }
}
