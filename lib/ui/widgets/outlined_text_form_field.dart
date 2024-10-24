import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../commons/values.dart';
import '../../commons/extensions.dart';

class OutlinedTextFormField extends StatelessWidget {
  const OutlinedTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.obscureText = false,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.maxLines = 1,
    this.enabled,
    this.filled,
    this.fillColor,
    this.labelStyle, this.contentPadding,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool? enabled;
  final bool? filled;
  final Color? fillColor;
  final TextStyle? labelStyle;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      enabled: enabled,
      maxLines: maxLines,
      style: context.textTheme.bodyLarge,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor,
        labelStyle: labelStyle,
        errorMaxLines: 2,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(
          vertical: DefaultValues.padding * 0.75,
          horizontal: DefaultValues.padding,
        ),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
