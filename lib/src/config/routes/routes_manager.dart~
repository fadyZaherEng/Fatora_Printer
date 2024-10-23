import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:fatora/src/presentation/screens/add_fatora/add_fatora_screen.dart';
import 'package:fatora/src/presentation/screens/main/screen/main_screen.dart';
import 'package:fatora/src/presentation/screens/print_fatora/print_fatora_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String main = "/";
  static const String printerFatora = "/printerFatora";
  static const String addFatora = "/addFatora";
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
          fatora: arg["fatora"]??const Fatora(),
        ));

      case Routes.printerFatora:
        Fatora? fatora = routeSettings.arguments as Fatora?;
        return _materialRoute(PrintFatoraScreen(fatora: fatora));

      case Routes.addFatora:
        return _materialRoute(const AddFatoraScreen());

      default:
        Map<String, dynamic> arg =
        routeSettings.arguments as Map<String, dynamic>;
        return _materialRoute(MainScreen(
          selectIndex: arg["selectIndex"] ?? 0,
          fatora: arg["fatora"]??const Fatora(),
        ));

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
