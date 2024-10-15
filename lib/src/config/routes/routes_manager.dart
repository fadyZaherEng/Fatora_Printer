import 'package:fatora/src/presentation/screens/main/screen/main_screen.dart';
import 'package:fatora/src/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splash = "/";
  static const String main = "/main";
}

class RoutesManager {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    print("Mobile routeSettings.name: ${routeSettings.name}");
    switch (routeSettings.name) {
      case Routes.main:
        Map<String, dynamic> arg =
            routeSettings.arguments as Map<String, dynamic>;
        return _materialRoute(MainScreen(
          selectIndex: arg["selectIndex"] ?? 0,
          isFromDeepLink: arg["isFromDeepLink"] ?? false,
          inviterName: arg["inviterName"] ?? "",
          unitName: arg["unitName"] ?? "",
        ));

      default:
        return _materialRoute(const SplashScreen());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }

  static Route<dynamic> unDefinedRoute(String name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Not found")),
        body: Center(
          child: Text(name),
        ),
      ),
    );
  }
}
