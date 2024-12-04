import 'dart:math';

import 'package:SindanoShow/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MyText extends StatelessWidget {
  String? text;
  double? fontsizeNormal, fontsizeWeb, letterSpacing;
  Color? color;
  dynamic maxline,
      fontstyle,
      fontweight,
      textalign,
      fontfamily,
      multilanguage,
      overflow;

  MyText({
    Key? key,
    required this.color,
    required this.text,
    this.multilanguage,
    this.fontsizeNormal,
    this.fontsizeWeb,
    this.letterSpacing,
    this.maxline,
    this.fontfamily,
    this.overflow,
    this.textalign,
    this.fontweight,
    this.fontstyle,
  }) : super(key: key);

  static getAdaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    if (kIsWeb || Constant.isTV) {
      return (value / 720) *
          min(MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width);
    } else {
      return (value / 720 * MediaQuery.of(context).size.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (multilanguage != null && multilanguage == true)
        ? LocaleText(
            text!,
            textAlign: textalign,
            overflow: TextOverflow.ellipsis,
            maxLines: maxline,
            style: GoogleFonts.inter(
              fontSize: getAdaptiveTextSize(context,
                  (kIsWeb || Constant.isTV) ? fontsizeWeb : fontsizeNormal),
              fontStyle: fontstyle,
              color: color,
              fontWeight: fontweight,
              letterSpacing: letterSpacing,
            ),
          )
        : Text(
            text!,
            textAlign: textalign,
            overflow: TextOverflow.ellipsis,
            maxLines: maxline,
            style: GoogleFonts.inter(
              fontSize: getAdaptiveTextSize(context,
                  (kIsWeb || Constant.isTV) ? fontsizeWeb : fontsizeNormal),
              fontStyle: fontstyle,
              color: color,
              fontWeight: fontweight,
              letterSpacing: letterSpacing,
            ),
          );
  }
}
