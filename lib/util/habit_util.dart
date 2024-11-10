//dar una lista de los habitos para completar en dias
//el habito esta completado hoy
bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) => 
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}