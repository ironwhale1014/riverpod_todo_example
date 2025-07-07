import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultLayout extends ConsumerWidget {
  const DefaultLayout({
    required this.title,
    required this.child,
    this.drawer,
    super.key,
  });

  final String? title;
  final Widget child;
  final Widget? drawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _renderAppBar(),
      body: child,
      drawer: drawer,
    );
  }

  AppBar? _renderAppBar() {
    if (title != null) {
      return AppBar(title: Text(title!));
    }

    return null;
  }
}
