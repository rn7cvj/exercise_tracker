import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class WeekdaySwitchController extends GetxController {
  WeekdaySwitchController(
      DateTime beginDay, DateTime selectedDay, DateTime endDay,
      {WeekBeginDays weekBeginDay = WeekBeginDays.Monday})
      : this.beginDay = trimDateTime(beginDay),
        this.selectedDay = trimDateTime(selectedDay).obs,
        this.endDay = trimDateTime(endDay),
        this.weekBeginDay = weekBeginDay {
    anchorBeginDay = getNearbyDay(beginDay, weekBeginDay);

    int weeksPageInit = getNearbyDay(selectedDay, weekBeginDay)
        .difference(anchorBeginDay)
        .inDays;

    weeksPageController = PageController(initialPage: weeksPageInit ~/ 7);

    currentDayPageController =
        PageController(initialPage: selectedDay.difference(beginDay).inDays);
  }

  // Первый отображаемый день
  final DateTime beginDay;

  // Выбранный день
  final Rx<DateTime> selectedDay;

  // Последний отображаемый день
  final DateTime endDay;

  // День с которого начинается неделя
  final WeekBeginDays weekBeginDay;

  // Первый день начала недели
  late DateTime anchorBeginDay;

  late PageController weeksPageController;

  late PageController currentDayPageController;

  void setSelectedDay(DateTime newSelectedDay){
    DateTime _newSelectedDay = trimDateTime(newSelectedDay);

    // Предыдушая неделя
    if (selectedDay().weekday == 1 &&
        _newSelectedDay.weekday == 7 &&
        _newSelectedDay.add(Duration(days: 1)) == selectedDay()) {
      weeksPageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }

    // Следующая неделя
    if (selectedDay().weekday == 7 &&
        _newSelectedDay.weekday == 1 &&
        _newSelectedDay.add(Duration(days: -1)) == selectedDay()) {
      weeksPageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }

    DateTime newDate = _newSelectedDay;
    selectedDay(newDate);

  }

  List<DateTime> getWeekDays(int weekIndex) {

    DateTime beginWeekDay = anchorBeginDay.add(Duration(days: 7 * weekIndex));
    
    List<DateTime> days = [];

    for (int shift = 0; shift < 7; shift++) {
      days.add(beginWeekDay.add(Duration(days: shift)));
    }

    return days;

  }

  // Окей тут смотрим только на месяц
  List<DateTime> getWeekMountData(int weekIndex) {
    List<DateTime> currentWeekDays = getWeekDays(weekIndex);

    for (int i = 0; i < currentWeekDays.length - 1; i++) {
      if (currentWeekDays[i].month != currentWeekDays[i + 1].month) {
        return [currentWeekDays[i], currentWeekDays[i + 1]];
      }
    }
    return [currentWeekDays.first];
  }

}

DateTime trimDateTime(DateTime dateTime) =>
    DateTime(dateTime.year, dateTime.month, dateTime.day);

DateTime getNearbyDay(DateTime dateTime, WeekBeginDays weekBeginDay) {
  dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 1));

  if (weekBeginDay.value <= dateTime.weekday) {
    dateTime.add(Duration(days: weekBeginDay.value - 1));
  }

  if (weekBeginDay.value > dateTime.weekday) {
    dateTime.subtract(Duration(days: 7 - (weekBeginDay.value - 1)));
  }

  return dateTime;
}

enum WeekBeginDays {
  Monday(1),
  Tuesday(2),
  Wednesday(3),
  Thursday(4),
  Friday(5),
  Saturday(6),
  Sunday(7);

  final int value;
  const WeekBeginDays(this.value);

  bool operator <(WeekBeginDays day) => value < day.value;
  bool operator >(WeekBeginDays day) => value > day.value;
}
