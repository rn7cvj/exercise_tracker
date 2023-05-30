import 'package:exercise_tracker/pages/calendar_page/widgets/week_day_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../i18n/strings.g.dart';

class CalendarPage extends GetView<void> {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.navbar.calendar),
      ),
      body: Column(
        children: [
          WeekdaySwitch(
            selectedDay: DateTime.now(),
            onDayChange: (selectedDay) {},
            dateContentBuilder: dateContetentBuilder,
          ),
        ],
      ),
    );
  }

  Widget dateContetentBuilder(context, day) {
    return Center(child: Text(day.toString()),);
  }
}
