import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:minimal_habit_tracker_luis_ake/models/app_settings.dart';
import 'package:minimal_habit_tracker_luis_ake/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier{
  static late Isar isar;



  /*
    S E T U P
  
   */

  // I N I C I A L I Z A R - B A S E D E D A T O S
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
     );
  }

  //guardar la primera fecha de la app (para el heatmap)
  Future<void> saveFirstLaunchDate() async{
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null ) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }
 
  //obtener la primera fecha de la app (para el heatmap)
  Future<DateTime?> getFirstLaunchDate() async{
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }


  /*

    operaciones del crud 

   */

  //lista de los habitos
  final List<Habit> currentHabits = [];

  //CREATE - añadir un nuevo habito
  Future<void> addHabit(String habitName) async{
    //crear un nuevo habito
    final newHabit = Habit()..name = habitName;

    //guardar a la base de datos
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //releer de la base de datos
    readHabits();
  }

  //READ - ver los habitos guardados de la base de datos
  Future<void> readHabits() async{
    //buscar todos los habitos de la base de datos
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //dar todos habitos de ahora
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    //actualizar la UI
    notifyListeners();
  }

  //UPDATE - marcar el habito como completado o no completado
  Future<void> updateHabitCompletion(int id, bool isCompleted) async{
    //buscar el habito
    final habit = await isar.habits.get(id);

    //actualizar el estado del habito
    if (habit != null){
      await isar.writeTxn(()async{
        //si el habito esta completado -> añadir la fecha actual a la lista de completedDays
        if (isCompleted && !habit.completedDays.contains(DateTime.now())){
          //hoy
          final today = DateTime.now();

          //añadir la fecha actual si no esta en la lista
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        }
        
        //si el habito no esta completado -> eliminar la fecha actual de la lista de completed
        else {
          //remover la fecha actual su el habito esta marcado como no completado
          habit.completedDays.removeWhere(
            (date) => 
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day,
          );
        }
        //guardar los habitos actualizados de vuelta a la base de datos
        await isar.habits.put(habit);
      });
    }


    //releer de la base de datos
    readHabits();
  }

  //UPDATE - editar el nombre del habito
  Future<void> updateHabitName(int id, String newName) async{
    //buscar el habito
    final habit = await isar.habits.get(id);

    //actualizar el nombre del habito
    if (habit != null){
      //actualizar el nombre
      await isar.writeTxn(()async{
        habit.name = newName;
        //guardar los habitos actualizados de vuelta a la base de datos
        await isar.habits.put(habit);
      });
    }

    //relectura de la base de datos
    readHabits();
  }

  //DELTE - borrar el habito
  Future<void> deleteHabit(int id) async{
    //borrar el habito
    await isar.writeTxn(()async{
      await isar.habits.delete(id);
    });

    //relectura de la base de datos
    readHabits();
  }
}