import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/calendar_page/week_day_switch_controller.dart';

class WeekdaySwitch extends StatelessWidget {
  WeekdaySwitch({
    super.key,
    required this.selectedDay,
    this.onDayChange,
    this.dateButtonBuilder,
    this.dateContentBuilder,
    this.showNavigationArrow = false,
  });

  bool showNavigationArrow;
  DateTime selectedDay;

  Widget Function(BuildContext context, DateTime day)? dateButtonBuilder;
  Widget Function(BuildContext context, DateTime day)? dateContentBuilder;

  void Function(DateTime selectedDay)? onDayChange;

  late final controller = Get.put(WeekdaySwitchController(
      DateTime(1900, 0, 0, 0, 0), selectedDay, DateTime(2300, 0, 0, 0, 0)));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: PageView.builder(
            itemBuilder: (cntx, index) => Container(color: Colors.amber),
          ),
        ),

        Expanded(
          child: PageView.builder(
            itemBuilder: (cntx, index) => Container(color: Colors.blue),
          ),
        )

        // // AppBar(
        // //   title: Obx(
        // //     () => Text(
        // //         controller
        // //             .mountData()
        // //             .map((mountData) => DateFormat.MMMM(
        // //                     Localizations.localeOf(context).toString())
        // //                 .format(mountData))
        // //             .join("-"),
        // //         style: context.textTheme.headlineLarge),
        // //   ),
        // //   actions: [
        // //     // IconButton(
        // //     //   onPressed: () {
        // //     //     controller.isExpanded(!controller.isExpanded());
        // //     //   },
        // //     //   icon: Obx(
        // //     //     () => controller.isExpanded()
        // //     //         ? Icon(Icons.arrow_drop_down_outlined)
        // //     //         : Icon(Icons.arrow_drop_up_outlined),
        // //     //   ),
        // //     // ),
        // //   ],
        // // ),

        // createWeekLine(context),

        // SizedBox(
        //   height: 100,
        //   child: PageView.builder(
        //     controller: controller.currentDayPageController,
        //     onPageChanged: (value) => controller.setSelectedDay(controller.beginDay.add(Duration(days: value))),
        //     itemBuilder: (context , dayIndex) {
        //       return Text(dayIndex.toString());
        //     }
        //   ),
        // ),

        // // if (dateContentBuilder != null) dateContentBuilder!(context, controller.selectedDay())
      ],
    );
  }

  SizedBox createWeekLine(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          showNavigationArrow
              ? IconButton(
                  onPressed: () => controller.weeksPageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  ),
                  icon: const Icon(Icons.arrow_back_ios),
                )
              : Container(),

          // main day picker
          Expanded(
            child: PageView.builder(
              controller: controller.weeksPageController,
              itemBuilder: (ctx, weekIndex) {
                return Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: createDaysCards(context, weekIndex),
                  ),
                );
              },
            ),
          ),

          showNavigationArrow
              ? IconButton(
                  onPressed: () => controller.weeksPageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn),
                  icon: const Icon(Icons.arrow_forward_ios),
                )
              : Container(),
        ],
      ),
    );
  }

  List<Widget> createDaysCards(BuildContext context, int weekIndex) {
    return controller
        .getWeekDays(weekIndex)
        .map((day) => dateButtonBuilder != null
            ? dateButtonBuilder!(context, day)
            : defaultDateBuilder(context, day))
        .toList();
  }

  Widget defaultDateBuilder(BuildContext context, DateTime day) {
    return Expanded(
      child: Card(
        color: controller.selectedDay() == day
            ? context.theme.colorScheme.secondaryContainer
            : null,
        elevation: controller.selectedDay() == day ? 3 : 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            controller.setSelectedDay(day);
            onDayChange!(day);
          },
          child: SizedBox(
            height: 55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.E(Localizations.localeOf(context).toString())
                      .format(day),
                  style: context.textTheme.titleMedium,
                ),
                Text(day.day.toString())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
