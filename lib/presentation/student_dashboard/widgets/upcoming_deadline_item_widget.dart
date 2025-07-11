import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UpcomingDeadlineItemWidget extends StatelessWidget {
  final String courseName;
  final String taskType;
  final String taskTitle;
  final DateTime dueDate;
  final bool isCompleted;
  final VoidCallback onMarkComplete;

  const UpcomingDeadlineItemWidget({
    super.key,
    required this.courseName,
    required this.taskType,
    required this.taskTitle,
    required this.dueDate,
    required this.isCompleted,
    required this.onMarkComplete,
  });

  String _getTimeRemaining() {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours left';
    } else {
      return '${difference.inMinutes} minutes left';
    }
  }

  Color _getUrgencyColor() {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (difference.inDays <= 1) {
      return AppTheme.warningLight;
    } else if (difference.inDays <= 3) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else {
      return AppTheme.lightTheme.colorScheme.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgencyColor = _getUrgencyColor();
    final timeRemaining = _getTimeRemaining();

    return Dismissible(
      key: Key('deadline_${courseName}_${taskTitle}'),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.onTertiary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Mark Complete',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (!isCompleted) {
          onMarkComplete();
          return true;
        }
        return false;
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isCompleted
              ? AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.7)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5)
                : AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          boxShadow: isCompleted
              ? null
              : [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Urgency Indicator
            Container(
              width: 1.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : urgencyColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(width: 3.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          taskTitle,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                            color: isCompleted
                                ? AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCompleted)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 5.w,
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          taskType,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '•',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          courseName,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: isCompleted
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : urgencyColor,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        isCompleted ? 'Completed' : timeRemaining,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isCompleted
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              : urgencyColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
