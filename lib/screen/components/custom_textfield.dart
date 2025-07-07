import 'package:drift_todo_train/common/const/ui_const.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final bool autofocus;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? errorText;
  final TextEditingController controller;
  final Widget? label;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  final baseBorder = UnderlineInputBorder(
    borderSide: BorderSide(width: 1.0, color: INPUT_BORDER_COLOR),
  );

  CustomTextFormField({
    super.key,
    this.autofocus = false,
    this.obscureText = false,
    this.onChanged,
    this.hintText,
    this.errorText,
    this.label,
    this.keyboardType,
    required this.controller,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      controller: controller,
      autofocus: autofocus,
      obscureText: obscureText,
      onChanged: onChanged,
      cursorColor: PRIMARY_COLOR,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: label,
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(color: BODY_TEXT_COLOR, fontSize: 14),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(color: PRIMARY_COLOR),
        ),
      ),
    );
  }
}
