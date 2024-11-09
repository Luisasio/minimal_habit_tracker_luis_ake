import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker_luis_ake/theme/dark_mode.dart';
import 'package:minimal_habit_tracker_luis_ake/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier{
  //Inicialmente, el tema blanco o luz
  ThemeData _themeData = lightMode;

  //obtener el tema actual
  ThemeData get themeData => _themeData;

  //el tema actual es el oscuro
  bool get isDarkMode => _themeData == darkMode;

  //definir el tema
  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  //altenrar el tema
  void toggleTheme() {
    if (_themeData == lightMode){
      themeData = darkMode;
    }else{
      themeData = lightMode;
    }
  }
}