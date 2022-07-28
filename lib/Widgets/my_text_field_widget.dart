import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';

class MyTextField extends StatelessWidget {
  final name;
  final formData;
  final label;
  final hint;
  final controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final Function(String?)? validator;
  final obscureText;
  final maxLength;
  final bool isFill;
  final String? prefixIcon;
  final Function()? onTap;
  final bool? readOnly;

  const MyTextField(
      {this.name,
      this.formData,
      this.label,
      this.hint,
      this.controller,
      this.textInputAction,
      this.keyboardType,
      this.validator,
      this.obscureText,
      this.maxLength,
      this.textCapitalization,
      this.isFill = false,
      this.prefixIcon,
      this.onTap,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          textInputAction: textInputAction ?? TextInputAction.done,
          keyboardType: keyboardType ?? TextInputType.text,
          obscureText: obscureText ?? false,
          maxLength: maxLength ?? 50,
          onTap: onTap ?? () {},
          cursorColor: AppColors.textWhiteColor,
          style: GoogleFonts.lato(
            color: AppColors.textWhiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          readOnly: readOnly!,
          decoration: prefixIcon == null
              ? CustomWidgets.customInputDecoration(hint: hint)
              : CustomWidgets.inputPrefixDecoration(
                  hint: hint, prefixIcon: prefixIcon),
          onChanged: (v) {
            if (formData != null && name != null) {
              formData[name] = v;
            }
          },
          validator: (v) => validator!(v),
        ),
      ],
    );
  }
}
