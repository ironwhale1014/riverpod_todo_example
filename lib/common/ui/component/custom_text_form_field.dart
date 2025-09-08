import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomTextFormField extends HookConsumerWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.onFieldSubmitted,
    this.hintText,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;
  final String? hintText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
