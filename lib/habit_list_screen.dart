import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'drawer_navigation.dart';
import 'edit_habit_screen.dart';
import 'habit_model.dart';
import 'habit_form_screen.dart';
import 'main.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({Key? key}) : super(key: key);

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  late List<HabitModel> _habitList;

  @override
  initState() {
    super.initState();
    getAllHabit();
  }

  getAllHabit() async {

    _habitList = <HabitModel>[];

    var habits = await dbHelper.queryAllRows(DatabaseHelper.habitsTable);

    habits.forEach((habit) {

        print(habit['_id']);
        print(habit['habit']);
        print(habit['priority']);
        print(habit['date']);
        print(habit['frequency']);

        var habitModel = HabitModel(habit['_id'], habit['habit'], habit['priority'],habit['date'], habit['frequency']);

        setState(() {
        _habitList.add(habitModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Habit List',
        ),
      ),
      drawer: DrawerNavigation(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
            key: UniqueKey(),
            itemCount: _habitList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: ListTile (
                    onTap: () {
                      print('---------->Edit or Delete invoked: Send Data');
                      print(_habitList[index].id);
                      print(_habitList[index].habit);
                      print(_habitList[index].priority);
                      print(_habitList[index].date);
                      print(_habitList[index].frequency);

                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => EditHabitScreen(),
                        settings: RouteSettings(
                          arguments: _habitList[index],
                        ),
                      ));
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_habitList[index].habit ?? 'No Data'),
                      ],
                    ),
                    subtitle: Text(_habitList[index].frequency ?? 'No Data'),
                    trailing: Text(_habitList[index].date ?? 'No Data'),
                  ),
                ),
              );
            }),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('---------->add invoked');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HabitFormScreen()));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}