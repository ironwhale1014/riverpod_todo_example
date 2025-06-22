import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultLayout extends ConsumerWidget {
  const DefaultLayout({
    super.key,
    this.title,
    this.appBarActions,
    required this.child,
  });

  final String? title;
  final List<Widget>? appBarActions;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _renderAppbar(), body: child);
  }

  AppBar? _renderAppbar() {
    if (title != null) {
      return AppBar(title: Text(title!), actions: appBarActions);
    }

    return null;
  }
}
