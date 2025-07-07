import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultLayout extends ConsumerWidget {
  const DefaultLayout({required this.title, super.key});

  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _renderAppBar());
  }

  AppBar? _renderAppBar() {
    if (title != null) {
      return AppBar(title: Text(title!));
    }

    return null;
  }
}
