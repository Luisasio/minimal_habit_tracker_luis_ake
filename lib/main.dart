import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker_luis_ake/database/habit_database.dart';
import 'package:minimal_habit_tracker_luis_ake/pages/home_page.dart';
import 'package:minimal_habit_tracker_luis_ake/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //inicializar la base de datos
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  runApp(
      MultiProvider(providers: [
        //proveedor de habitos
        ChangeNotifierProvider(create: (context) => HabitDatabase()),

        //proveedor de tema
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

