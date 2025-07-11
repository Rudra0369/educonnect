import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizTimerWidget extends StatelessWidget {
  final int timeRemaining;

  const QuizTimerWidget({
    Key? key,
    required this.timeRemaining,
  }) : super(key: key);

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    if (timeRemaining > 300) {
      // More than 5 minutes
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (timeRemaining > 60) {
      // More than 1 minute
      return Colors.orange;
    } else {
      // Less than 1 minute
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: _getTimerColor().withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'timer',
            color: _getTimerColor(),
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            'Time Remaining: ${_formatTime(timeRemaining)}',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: _getTimerColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
