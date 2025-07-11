import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CourseHeroWidget extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final VoidCallback onPlayPreview;

  const CourseHeroWidget({
    Key? key,
    required this.courseData,
    required this.onPlayPreview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instructor = courseData["instructor"] as Map<String, dynamic>? ?? {};

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course thumbnail with play button
          Container(
            width: double.infinity,
            height: 25.h,
            child: Stack(
              children: [
                CustomImageWidget(
                  imageUrl: courseData["thumbnail"] as String? ?? "",
                  width: double.infinity,
                  height: 25.h,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 25.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: onPlayPreview,
                    child: Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'play_arrow',
                        color: Colors.white,
                        size: 8.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Course info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course title
                Text(
                  courseData["title"] as String? ?? "",
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 1.h),

                // Rating and students
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: Colors.amber,
                      size: 18,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "${courseData["rating"] ?? 0.0}",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "(${courseData["reviewsCount"] ?? 0} reviews)",
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    SizedBox(width: 3.w),
                    CustomIconWidget(
                      iconName: 'people',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "${courseData["studentsEnrolled"] ?? 0} students",
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),

                SizedBox(height: 1.5.h),

                // Instructor info
                Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: instructor["avatar"] as String? ?? "",
                          width: 10.w,
                          height: 10.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            instructor["name"] as String? ?? "",
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            instructor["credentials"] as String? ?? "",
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Course metadata
                Wrap(
                  spacing: 4.w,
                  runSpacing: 1.h,
                  children: [
                    _buildMetadataItem(
                      icon: 'schedule',
                      text: courseData["duration"] as String? ?? "",
                    ),
                    _buildMetadataItem(
                      icon: 'play_lesson',
                      text: "${courseData["lessonsCount"] ?? 0} lessons",
                    ),
                    _buildMetadataItem(
                      icon: 'trending_up',
                      text: courseData["level"] as String? ?? "",
                    ),
                    _buildMetadataItem(
                      icon: 'language',
                      text: courseData["language"] as String? ?? "",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem({required String icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
