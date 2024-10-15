
import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:fatora/src/core/resources/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomSheetWidget extends StatelessWidget {
  final Widget content;
  final String titleLabel;
  final double height;
  final bool isTitleVisible;
  final bool isTitleImage;
  final Widget? imageWidget;

  const BottomSheetWidget({
    Key? key,
    required this.content,
    required this.titleLabel,
    this.height = 300,
    this.isTitleVisible = true,
    this.isTitleImage = false,
    this.imageWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: ColorSchemes.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          topLeft: Radius.circular(32),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(32),
          topLeft: Radius.circular(32),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: isTitleImage || imageWidget != null ? 20 : 0),
                  const Expanded(child: SizedBox()),
                  if (isTitleImage && imageWidget == null)
                    SvgPicture.asset(
                     " ImagePaths.logo",
                      height: 70,
                      width: 70,
                    ),
                  if (isTitleImage && imageWidget != null)
                    imageWidget ?? const SizedBox.shrink(),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      "ImagePaths.close",
                      height: 20,
                      width: 20,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isTitleVisible,
              child: Text(
                titleLabel,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: ColorSchemes.black,
                    fontSize: 18,
                    letterSpacing: -0.24),
              ),
            ),
            Visibility(
              visible: isTitleVisible,
              child: const SizedBox(height: 0),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
