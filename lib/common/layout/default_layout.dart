import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultLayout extends ConsumerWidget {
  const DefaultLayout({required this.title, required this.child, super.key});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _renderAppBar(), body: child);
  }

  AppBar? _renderAppBar() {
    if (title != null) {
      return AppBar(title: Text(title!));
    }

    return null;
  }
}
