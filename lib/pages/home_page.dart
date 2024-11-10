import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker_luis_ake/components/my_drawer.dart';
import 'package:minimal_habit_tracker_luis_ake/components/my_habit_tile.dart';
import 'package:minimal_habit_tracker_luis_ake/database/habit_database.dart';
import 'package:minimal_habit_tracker_luis_ake/models/habit.dart';
import 'package:minimal_habit_tracker_luis_ake/util/habit_util.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {

    //leer los habitos existentes en el inicio de la app
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  //controlador de texto
  final TextEditingController textControler= TextEditingController();

  //crear un nuevo habito
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textControler,
          decoration: const InputDecoration(
            hintText: "Crear un nuevo habito"
          ),
        ),
        actions: [
            //boton guardar
            MaterialButton(onPressed: (){
              //guardar el nuevo habito
              String newHabitName = textControler.text;

              //guaradar en la base de datos
              context.read<HabitDatabase>().addHabit(newHabitName);

              //caja pop
              Navigator.pop(context);

              //limpiar
              textControler.clear();
            },
            child: const Text('guardar'),
            ),

            //boton cancelar
            MaterialButton(onPressed: (){
              //cerrar la caja
              Navigator.pop(context);

              //limpiar
              textControler.clear();
            },
          child: const Text('Cancelar'),
          )
        ],
      ),
    );
  }

  // marcar el habito si o no
  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }


    //caja de editar habito
    void editHabitBox(Habit habit){
      //definir el controlador del texto del habito actual
      textControler.text = habit.name;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textControler,
          ),
          actions: [
            //boton guardar
            MaterialButton(
              onPressed: (){
                //guardar el nuevo habito
                String newHabitName = textControler.text;

                //guaradar en la base de datos
                context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);

                //caja pop
                Navigator.pop(context);

                //limpiar
                textControler.clear();
            },
            child: const Text('guardar'),
            ),

            //boton cancelar
            MaterialButton(onPressed: (){
              //cerrar la caja
              Navigator.pop(context);

              //limpiar
              textControler.clear();
            },
          child: const Text('Cancelar'),
          )
          ],
      ),
    );
  }

  //caja de borrar habito
  void deleteHabitBox(Habit habit){
    //definir el controlador del texto del habito actual
      textControler.text = habit.name;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
         title: const Text('Estas seguro que quieres borrar?'),
          actions: [
            //boton borrar
            MaterialButton(
              onPressed: (){
                
                //guaradar en la base de datos
                context.read<HabitDatabase>().deleteHabit(habit.id);

                //caja pop
                Navigator.pop(context);
            },
            child: const Text('Borrar'),
            ),

            //boton cancelar
            MaterialButton(onPressed: (){
              //cerrar la caja
              Navigator.pop(context);

            },
          child: const Text('Cancelar'),
          )
          ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
        ),
      body: _buildHabitList(),
    );
    
  }

  //construir la lista de habitos
  Widget _buildHabitList() {
      //habito de la base de datos
      final habitDatabase = context.watch<HabitDatabase>();

      //habitos actuales
      List<Habit> currentHabits = habitDatabase.currentHabits;

      //retornar la lista de habitos en la interfaz
      return ListView.builder(
        itemCount: currentHabits.length,
        itemBuilder: (context, index) {
        //obener cada habito individual
        final habit = currentHabits[index];

        //verificar si el habito ha sido completado hoy
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        //devolver el habito a la interfaz
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      }
    );
  }
}