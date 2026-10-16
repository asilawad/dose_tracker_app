import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleEmptyState extends StatelessWidget {
  const ScheduleEmptyState({required this.totalCount, super.key});

  final int totalCount;

  @override
  Widget build(BuildContext context) {
    if (totalCount == 0) {
      return EmptyState(
        icon: Icons.event_available_rounded,
        title: AppStrings.scheduleEmptyTitle.tr,
        message: AppStrings.scheduleEmptyMessage.tr,
      );
    }
    return Center(
      child: Text(
        AppStrings.scheduleAllDone.tr,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
