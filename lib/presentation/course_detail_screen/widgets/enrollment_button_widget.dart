import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EnrollmentButtonWidget extends StatelessWidget {
  final String enrollmentStatus;
  final String price;
  final String originalPrice;
  final bool isLoading;
  final VoidCallback onEnroll;
  final VoidCallback onContinue;

  const EnrollmentButtonWidget({
    Key? key,
    required this.enrollmentStatus,
    required this.price,
    required this.originalPrice,
    required this.isLoading,
    required this.onEnroll,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price information (only for not enrolled)
            if (enrollmentStatus == "not_enrolled") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (originalPrice.isNotEmpty) ...[
                    Text(
                      originalPrice,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                  ],
                  Text(
                    price,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
            ],

            // Enrollment button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : _getButtonAction(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(context),
                  foregroundColor: _getButtonTextColor(context),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: _getButtonIcon(),
                            color: _getButtonTextColor(context),
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _getButtonText(),
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _getButtonTextColor(context),
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Additional info for enrolled students
            if (enrollmentStatus == "enrolled") ...[
              SizedBox(height: 1.h),
              Text(
                "You are enrolled in this course",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Completion message
            if (enrollmentStatus == "completed") ...[
              SizedBox(height: 1.h),
              Text(
                "Congratulations! You've completed this course",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  VoidCallback? _getButtonAction() {
    switch (enrollmentStatus) {
      case "not_enrolled":
        return onEnroll;
      case "enrolled":
        return onContinue;
      case "completed":
        return onContinue;
      default:
        return onEnroll;
    }
  }

  String _getButtonText() {
    switch (enrollmentStatus) {
      case "not_enrolled":
        return "Enroll Now";
      case "enrolled":
        return "Continue Learning";
      case "completed":
        return "Review Course";
      default:
        return "Enroll Now";
    }
  }

  String _getButtonIcon() {
    switch (enrollmentStatus) {
      case "not_enrolled":
        return "shopping_cart";
      case "enrolled":
        return "play_arrow";
      case "completed":
        return "replay";
      default:
        return "shopping_cart";
    }
  }

  Color _getButtonColor(BuildContext context) {
    switch (enrollmentStatus) {
      case "not_enrolled":
        return AppTheme.lightTheme.colorScheme.primary;
      case "enrolled":
        return AppTheme.lightTheme.colorScheme.tertiary;
      case "completed":
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  Color _getButtonTextColor(BuildContext context) {
    switch (enrollmentStatus) {
      case "not_enrolled":
        return AppTheme.lightTheme.colorScheme.onPrimary;
      case "enrolled":
        return AppTheme.lightTheme.colorScheme.onTertiary;
      case "completed":
        return AppTheme.lightTheme.colorScheme.onSecondary;
      default:
        return AppTheme.lightTheme.colorScheme.onPrimary;
    }
  }
}
