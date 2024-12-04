import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String? title, subTitle;
  const NoData({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: transparent,
        borderRadius: BorderRadius.circular(12),
        shape: BoxShape.rectangle,
      ),
      constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyImage(
            height: 180,
            fit: BoxFit.contain,
            imagePath: "nodata.png",
          ),
          const SizedBox(height: 20),
          (title ?? "") != ""
              ? MyText(
                  color: colorPrimaryDark,
                  text: title ?? "",
                  fontsizeNormal: 16,
                  fontsizeWeb: 18,
                  maxline: 2,
                  multilanguage: true,
                  overflow: TextOverflow.ellipsis,
                  fontweight: FontWeight.w600,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 8),
          (subTitle ?? "") != ""
              ? MyText(
                  color: otherColor,
                  text: subTitle ?? "",
                  fontsizeNormal: 14,
                  fontsizeWeb: 16,
                  maxline: 5,
                  multilanguage: true,
                  overflow: TextOverflow.ellipsis,
                  fontweight: FontWeight.w500,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
