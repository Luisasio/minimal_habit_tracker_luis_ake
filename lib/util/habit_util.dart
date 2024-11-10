//dar una lista de los habitos para completar en dias
//el habito esta completado hoy
import 'package:minimal_habit_tracker_luis_ake/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) => 
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}


// preparar los datos del heatmap
Map<DateTime, int> prepareHeatMapDataset(List<Habit> habits){
  Map<DateTime, int> dataset = {};

  for (var habit in habits){
    for (var date in habit.completedDays) {
      //Normalizar la fecha para evitar desajustes
      final normalizedDate = DateTime(date.year, date.month, date.day);

      //si el dato ya existe incrementar el contador
      if (dataset.containsKey(normalizedDate)){
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      }else{
        //de lo contrario se inicializa con 1
        dataset[normalizedDate] = 1;
      }
    }
  }

  return dataset;
}