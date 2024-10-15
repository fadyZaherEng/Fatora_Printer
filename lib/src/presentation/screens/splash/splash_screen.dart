// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:fatora/src/config/routes/routes_manager.dart';
import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.main, (route) => false,
          arguments: {
            "selectIndex": 0,
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: ColorSchemes.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Expanded(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    RotationTransition(
                      turns: _animation,
                      child: SvgPicture.asset(
                        width: 232,
                        height: 232,
                        " ImagePaths.switchSplash",
                        fit: BoxFit.cover,
                        color: ColorSchemes.primary,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorSchemes.greyDivider,
                          // color of the border
                          width: 2, // width of the border
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          height: 130,
                          width: 130,
                          "_switchLogo",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            height: 130,
                            width: 130,
                            " ImagePaths.imagePlaceHolder",
                            fit: BoxFit.cover,
                          ),
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 130,
                              height: 130,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorSchemes.primary,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Text(
                //   GetUserUnitUseCase(injector())().compoundName,
                //   style: Theme
                //       .of(context)
                //       .textTheme
                //       .bodyLarge!
                //       .copyWith(
                //     color: ColorSchemes.primary,
                //     fontSize: 20,
                //     letterSpacing: -0.24,
                //   ),
                // ),
                // const SizedBox(
                //   height: 8,
                // ),
                // Text(
                //   GetUserUnitUseCase(injector())().unitName,
                //   style: Theme
                //       .of(context)
                //       .textTheme
                //       .bodyMedium!
                //       .copyWith(
                //     color: ColorSchemes.primary,
                //     fontSize: 20,
                //     letterSpacing: -0.24,
                //   ),
                // ),
                const Expanded(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                Image.asset(
                  width: 120,
                  height: 120,
                  "ImagePaths.splashLogo",
                ),
                const SizedBox(
                  height: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    _controller.dispose();
    super.dispose();
  }
}
