import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:patroleum_app/repository/app.dart';
import 'package:patroleum_app/page/splash.dart';
// import 'package:patroleum_app/repository/shared_preferences.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level =
      kDebugMode ? Level.ALL : Level.INFO; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    //TODO use crashlytics?
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });
  // await PreferencesUser().initiPrefs();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Patroleum',
        theme: ThemeData(useMaterial3: true),
        home: RepositoryProvider(
            create: (context) => const AppRepository(), child: const Splash()));
  }
}
