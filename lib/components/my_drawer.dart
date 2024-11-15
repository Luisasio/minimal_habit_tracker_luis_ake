// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker_luis_ake/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  //en esta seccion hacemos el drawer para que pongamos el switch que cambiara de tema
  @override
  Widget build(BuildContext context) {
    return Drawer(
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Center(
          child: Switch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) => 
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
        ),
      );
  }
}