import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultLayout extends ConsumerWidget {
  const DefaultLayout({
    super.key,
    this.title,
    required this.child,
    this.drawer,
  });

  final String? title;
  final Widget child;
  final Widget? drawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _renderAppbar(), body: child, drawer: drawer);
  }

  AppBar? _renderAppbar() {
    if (title != null) {
      return AppBar(title: Text(title!));
    }
    return null;
  }
}
