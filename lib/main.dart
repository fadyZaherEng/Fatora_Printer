import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:fatora/generated/l10n.dart';
import 'package:fatora/src/config/routes/routes_manager.dart';
import 'package:fatora/src/di/injector.dart';
import 'package:fatora/src/presentation/widgets/restart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  runApp(
    const RestartWidget(MyApp()),
  );
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [
        ChuckerFlutter.navigatorObserver,
        routeObserver,
      ],
      themeMode: ThemeMode.light,
      supportedLocales: S.delegate.supportedLocales,
      onGenerateRoute: RoutesManager.getRoute,
      initialRoute: Routes.splash,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Fatora',
      // theme: AppTheme(state.languageCode).light,
      // locale: state,
    );
  }
}
