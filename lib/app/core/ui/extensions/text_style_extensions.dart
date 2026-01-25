import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager/app/core/ui/styles/colors_app.dart';

extension TextStyleExtensions on TextStyle {
  ColorsApp get _colorsApp => ColorsApp.i;

  TextStyle _customTextStyle({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? wordSpacing,
    double? height,
  }) => GoogleFonts.poppins(
    color: color ?? _colorsApp.black,
    fontSize: fontSize,
    fontWeight: fontWeight,
    wordSpacing: wordSpacing,
    height: height,
  );

  TextStyle get largeText => _customTextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500);
  TextStyle get mediumText => _customTextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500);
  TextStyle get smallText => _customTextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);
  TextStyle buttom({Color? color}) => _customTextStyle(color: color ?? _colorsApp.white, fontSize: 16.sp);
  TextStyle get inputText => _customTextStyle(fontSize: 16.sp, color: _colorsApp.gray, fontWeight: FontWeight.w400);

}
