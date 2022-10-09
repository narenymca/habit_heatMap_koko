import 'package:flutter/material.dart';
import 'package:habit_hive_koko/data/habit_database.dart';
import 'package:habit_hive_koko/widgets/alert_box.dart';
import 'package:habit_hive_koko/widgets/heat_map.dart';
import 'package:hive/hive.dart';

import '../widgets/fab.dart';
import '../widgets/habit_tile.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _mybox = Hive.box('Database');

  @override
  void initState() {
    // for first time users

    if (_mybox.get('CURRENT_HABIT_LIST') == null) {
      db.createDefaultData();
    }

    //for the old users
    else {
      db.loadData();
    }
    db.updateData();
    // TODO: implement initState
    super.initState();
  }

  // function to change the check boxes
  void _checkBoxTapped(bool value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateData();
  }

  //function to create new habit from fab
  final _newHabitNameController = TextEditingController();
  void _onsave() {
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    db.updateData();
    Navigator.of(context).pop();
    _newHabitNameController.clear();
  }

  void _oncancel() {
    Navigator.of(context).pop();
    _newHabitNameController.clear();
  }

  void _createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => MyAlertBox(
        hintText: 'Enter New Habit',
        controller: _newHabitNameController,
        onsave: _onsave,
        oncancel: _oncancel,
      ),
    );
  }

  void _settingTapped(int index) {
    showDialog(
      context: context,
      builder: (context) => MyAlertBox(
        hintText: db.todaysHabitList[index][0],
        controller: _newHabitNameController,
        onsave: () => _saveExistingHabitName(index),
        oncancel: _oncancel,
      ),
    );
  }

  void _saveExistingHabitName(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    db.updateData();
    Navigator.of(context).pop();
    _newHabitNameController.clear();
  }

  void _deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: [
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate: _mybox.get('START_DATE'),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todaysHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                title: db.todaysHabitList[index][0],
                isHabitCompleted: db.todaysHabitList[index][1],
                onChanged: (value) => _checkBoxTapped(value!, index),
                settingsTapped: (context) => _settingTapped(index),
                deleteTapped: (context) => _deleteHabit(index),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Fab(onPressed: _createNewHabit),
    );
  }
}
