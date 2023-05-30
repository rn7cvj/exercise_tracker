import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WeekdaySwitchController extends GetxController {
  WeekdaySwitchController(DateTime selectedDay) {
    this.selectedDay(selectedDay);
  }

  late RxBool isExpanded = false.obs;

  // Отвечает за переключение выбранной недели
  late PageController weeksPageController;

  late PageController currentDayPageController;

  // Выбранный день
  // Считаем что время в этой переменной всегда стоит на 00:00:00
  late Rx<DateTime> selectedDay = DateTime.now().obs;

  // Смотрим только на месяц и год
  late RxList<DateTime> mountData = <DateTime>[].obs;

  late RxList<DateTime> selectedWeekDays = <DateTime>[].obs;

  // День от которого ведеться отсчет недель
  late DateTime anchorDay = DateTime.now();

  // День начала отсчета нулевой недели
  late DateTime anchorStartWeekday;

  // Так считаем недели с понедельника
  late int startWeekdayIndex = 0;

  // Кол-во показываемых пердыдущих недель
  late int previousWeekShowCount = 2;

  // Индекс выбранной недели, считаем что текующая неделя имеет индекс 0
  // прошлые недели имеют индекс с минусом, будущие с плюсом
  // Пока пиздеж и это не так работатет
  late int selectedWeekIndex = 0;

  void setSelectedWeekIndex(int newWeekIndex) {
    selectedWeekIndex = newWeekIndex;
    mountData(getSelectedWeekMountData());
    selectedWeekDays(getSelectedWeekDays());
  }

  // Меняет выбранный день, для подстраховки обрезает время у входящей даты
  void setSelectedDay(DateTime newSelectedDay) {


    DateTime _newSelectedDay =
        DateTime(newSelectedDay.year, newSelectedDay.month, newSelectedDay.day);

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

  List<DateTime> getSelectedWeekDays() {
    int currentWeek = selectedWeekIndex;
    currentWeek -= previousWeekShowCount;
    DateTime selectedWeekStart =
        anchorStartWeekday.add(Duration(days: 7 * currentWeek));

    List<DateTime> days = [];

    for (int shift = 0; shift < 7; shift++) {
      days.add(selectedWeekStart.add(Duration(days: shift)));
    }

    return days;
  }

  // Окей тут смотрим только на месяц
  List<DateTime> getSelectedWeekMountData() {
    List<DateTime> currentWeekDays = getSelectedWeekDays();

    for (int i = 0; i < currentWeekDays.length - 1; i++) {
      if (currentWeekDays[i].month != currentWeekDays[i + 1].month) {
        return [currentWeekDays[i], currentWeekDays[i + 1]];
      }
    }
    return [currentWeekDays.first];
  }

  @override
  void onInit() {
    anchorDay = DateTime(anchorDay.year, anchorDay.month, anchorDay.day);
    selectedDay(
        DateTime(selectedDay().year, selectedDay().month, selectedDay().day));

    // Ищем ближайщий понедельнки
    anchorStartWeekday = DateTime(anchorDay.year, anchorDay.month,
        anchorDay.day - (anchorDay.weekday - 1) % 7);

    anchorStartWeekday =
        anchorStartWeekday.add(Duration(days: startWeekdayIndex));

    weeksPageController = PageController(initialPage: previousWeekShowCount);

    currentDayPageController = PageController(initialPage: previousWeekShowCount * 7 + selectedDay().weekday  - 1);

    selectedWeekIndex = previousWeekShowCount;

    mountData(getSelectedWeekMountData());
    selectedWeekDays(getSelectedWeekDays());

    super.onInit();
  }
}
