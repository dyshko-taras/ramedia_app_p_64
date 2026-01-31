import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    super.key,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.textStyle,
    this.autofocus = false,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final String? Function(String value)? validator;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final bool autofocus;
  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: textStyle ?? AppTextStyles.input,
      autofocus: autofocus,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator == null ? null : (value) => validator!(value ?? ''),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        contentPadding: Insets.allMd,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
