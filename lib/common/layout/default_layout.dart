import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultLayout extends ConsumerWidget {
  const DefaultLayout({
    super.key,
    this.title,
    required this.child,
    this.drawer,
    this.actions,
  });

  final String? title;
  final Widget child;
  final Widget? drawer;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _renderAppbar(), body: child, drawer: drawer);
  }

  AppBar? _renderAppbar() {
    if (title != null) {
      return AppBar(title: Text(title!), actions: actions);
    }
    return null;
  }
}
