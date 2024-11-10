import 'package:isar/isar.dart';

//correr en el cmd para generar un archivo: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit{
  //id del habito
  Id id = Isar.autoIncrement;

  //nombre del habito
  late String name;

  //dias completados
  List<DateTime> completedDays = [
    //Fecha (año, mes, dia)
  ];
}