import 'package:fatora/generated/l10n.dart';
import 'package:fatora/src/config/routes/routes_manager.dart';
import 'package:fatora/src/di/injector.dart';
import 'package:fatora/src/presentation/screens/main/screen/main_screen.dart';
import 'package:fatora/src/presentation/widgets/restart_widget.dart';
import 'package:flutter/material.dart';
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
        routeObserver,
      ],
      themeMode: ThemeMode.light,
      supportedLocales: S.delegate.supportedLocales,
      onGenerateRoute: RoutesManager.getRoute,
      home: const MainScreen(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Fatora',
      locale: const Locale('ar'),
    );
  }
}
//sqflite using
// DatabaseHelper dbHelper = DatabaseHelper();
//
// // Insert a new user
// await dbHelper.insertUser(User(name: 'John Doe', age: 25));
//
// // Get all users
// List<User> users = await dbHelper.getUsers();
// print('All Users: $users');
//
// // Update a user
// User updatedUser = users.first;
// updatedUser.name = 'John Smith';
// await dbHelper.updateUser(updatedUser);
//
// // Delete a user
// await dbHelper.deleteUser(updatedUser.id!);
//
// // Close the database
// await dbHelper.close();
