import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator; // ✅ добавляем validator
  final String labelText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final bool? filled;
  final bool enabled;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? maxLines, minLines;

  const MyTextfield({
    this.maxLines,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.filled,
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    required this.labelText,

    this.controller,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: obscureText && (maxLines == null || maxLines == 1),
          maxLines: obscureText ? 1 : maxLines,
          minLines: obscureText ? null : minLines,
          keyboardType: keyboardType,
          enabled: enabled,

          controller: controller,
          textInputAction: textInputAction,
          validator: validator,
          decoration: InputDecoration(
            filled: filled,
            fillColor: Colors.grey.shade200,
            hintStyle: const TextStyle(color: Color(0xFF9C9D9E)),
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff000000)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xffE53935), // насыщенный красный
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xffD32F2F), // чуть темнее при фокусе
                width: 1,
              ),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
