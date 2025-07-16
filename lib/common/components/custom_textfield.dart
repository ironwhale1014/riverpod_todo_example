import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomTextfield extends ConsumerStatefulWidget {
  const CustomTextfield({
    super.key,
    required this.controller,
    this.validator,
    this.onFieldSubmitted,
    this.hintText,
  });

  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final String? hintText;

  @override
  ConsumerState createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends ConsumerState<CustomTextfield> {
  late final TextEditingController controller;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onFieldSubmitted;
  String? hintText;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    if (widget.validator != null) {
      validator = widget.validator;
    }
    if (widget.onFieldSubmitted != null) {
      onFieldSubmitted = widget.onFieldSubmitted;
    }
    if (widget.hintText != null) {
      hintText = widget.hintText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
