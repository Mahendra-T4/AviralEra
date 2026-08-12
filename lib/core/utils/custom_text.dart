import 'package:flutter/material.dart';
import 'package:online_course/assets/font_family.dart';
import 'package:online_course/core/constants/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    required this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.5,
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.decorationThickness = 1.0,
    this.shadows,
    this.isSemibold = false,
  });

  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final double letterSpacing;
  final double lineHeight;
  final TextDecoration decoration;
  final Color? decorationColor;
  final double decorationThickness;
  final List<Shadow>? shadows;
  final bool isSemibold;

  @override
  Widget build(BuildContext context) {
    // Use theme-aware color if not provided
    final textColor = color ?? AppColors.getTextColor(context);

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
        fontFamily: isSemibold
            ? FontFamily.poppinsSemibold
            : FontFamily.poppinsMedium,
        letterSpacing: letterSpacing,
        height: lineHeight,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        shadows: shadows,
      ),
    );
  }
}
