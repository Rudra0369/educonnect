import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityItemWidget extends StatelessWidget {
  final Map<String, dynamic> activity;
  final VoidCallback onTap;

  const ActivityItemWidget({
    Key? key,
    required this.activity,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(activity["studentAvatar"] as String),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          activity["studentName"] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildActivityIcon(),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${activity["action"]} ${activity["courseName"]}${_getScoreText()}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    activity["timestamp"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIcon() {
    String iconName;
    Color iconColor;

    switch (activity["type"] as String) {
      case "enrollment":
        iconName = "person_add";
        iconColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case "quiz_completion":
        iconName = "quiz";
        iconColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case "message":
        iconName = "message";
        iconColor = Colors.orange;
        break;
      default:
        iconName = "info";
        iconColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: iconColor,
        size: 16,
      ),
    );
  }

  String _getScoreText() {
    if (activity["type"] == "quiz_completion" && activity["score"] != null) {
      return " (${activity["score"]}%)";
    }
    return "";
  }
}
