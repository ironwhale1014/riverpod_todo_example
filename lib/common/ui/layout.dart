import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultLayout extends ConsumerWidget {
  const DefaultLayout({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _renderAppbar(),
      resizeToAvoidBottomInset: false,
      body: child,
    );
  }

  AppBar? _renderAppbar() {
    if (title != null) {
      return AppBar(title: Text(title!));
    }
    return null;
  }
}
