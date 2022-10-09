import 'package:habit_hive_koko/date_time/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box('Database');

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  //load the firsttime data
  void createDefaultData() {
    todaysHabitList = [
      ['Running', false],
      ['Reading', false],
    ];
    _myBox.put('START_DATE', todaysDateFormatted());
  }

  //load the data if already exists
  void loadData() {
    //check new date
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get('CURRENT_HABIT_LIST');
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    }
    //if not new date
    else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  //update the database
  void updateData() {
    //update the todays entry
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    //update the master list
    _myBox.put('CURRENT_HABIT_LIST', todaysHabitList);
    //calculate the heat percentage
    calculateHabitPercentage();
    //load heatmap
    loadHeatMap();
  }

  void calculateHabitPercentage() {
    int counter = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        counter++;
      }
    }
    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (counter / todaysHabitList.length).toStringAsFixed(1);
    //loading the data key:'PERCENTAGE_SUMMARY_yyyyMMdd'
    //value: percent value 0.0 to 1.0
    _myBox.put('PERCENTAGE_SUMMARY_${todaysDateFormatted()}', percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObj(_myBox.get('START_DATE'));
    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );
      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );
      // split the datetime up like below so it doesn't worry about hours/mins/secs etc.
      // year
      int year = startDate.add(Duration(days: i)).year;
      // month
      int month = startDate.add(Duration(days: i)).month;
      // day
      int day = startDate.add(Duration(days: i)).day;
      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };
      heatMapDataSet.addEntries(percentForEachDay.entries);

      print(heatMapDataSet);
    }
  }
}
