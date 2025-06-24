import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultLayout extends ConsumerWidget {
  const DefaultLayout({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _renderAppbar(), body: child);
  }

  AppBar? _renderAppbar() {
    if (title != null) {
      return AppBar(title: Text(title!));
    }
    return null;
  }
}
