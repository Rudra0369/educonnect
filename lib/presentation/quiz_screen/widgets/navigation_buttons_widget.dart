import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NavigationButtonsWidget extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final bool hasAnswer;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  const NavigationButtonsWidget({
    Key? key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.hasAnswer,
    required this.onPrevious,
    required this.onNext,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = currentIndex == totalQuestions - 1;
    final isFirstQuestion = currentIndex == 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (!isFirstQuestion) ...[
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: onPrevious,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
            ],
            Expanded(
              flex: isFirstQuestion ? 1 : 2,
              child: ElevatedButton.icon(
                onPressed:
                    hasAnswer ? (isLastQuestion ? onSubmit : onNext) : null,
                icon: CustomIconWidget(
                  iconName: isLastQuestion ? 'check' : 'arrow_forward',
                  color: hasAnswer
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                  size: 20,
                ),
                label: Text(isLastQuestion ? 'Submit Quiz' : 'Next Question'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasAnswer
                      ? (isLastQuestion
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.primary)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  foregroundColor: hasAnswer
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: hasAnswer ? 2 : 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
