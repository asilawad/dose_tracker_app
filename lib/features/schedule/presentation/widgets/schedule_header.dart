import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/features/schedule/controllers/schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleHeader extends GetView<ScheduleController> {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: <Widget>[
        Text(AppStrings.scheduleToday.tr, style: textTheme.headlineMedium),
        Text(
          DateFormatter.fullDate(DateTime.now()),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.scheduleTakenProgress.trParams(<String, String>{
            'taken': '${controller.takenCount}',
            'total': '${controller.totalCount}',
          }),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
