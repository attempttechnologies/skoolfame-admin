import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skoolfame/Utils/app_colors.dart';

class MyButton extends StatelessWidget {
  final String? label;
  final onPressed;
  final width;
  final height;
  final padding;
  final TextStyle? textStyle;
  final color;
  final rightIcon;
  final Color borderColor;
  final Color labelTextColor;
  final double borderRadius;
  final Widget? child;
  const MyButton(
      {this.label,
      @required this.onPressed,
      this.width,
      this.height,
      this.padding,
      this.textStyle,
      this.color,
      this.rightIcon,
      this.borderRadius = 12.0,
      this.borderColor = AppColors.textWhiteColor,
      this.labelTextColor = Colors.black,
      this.child});

  @override
  Widget build(BuildContext context) {
    var defaultWidth = MediaQuery.of(context).size.width * 0.40;

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 10.0,
            ),
        child: Center(
          child: child ??
              Text(label!,
                  style: textStyle ??
                      GoogleFonts.lato(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: labelTextColor)),
        ),
        decoration: BoxDecoration(
          color: onPressed != null
              ? color ?? AppColors.textWhiteColor
              : Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
