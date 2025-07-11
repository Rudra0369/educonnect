import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InstructorInfoWidget extends StatelessWidget {
  final Map<String, dynamic> instructor;
  final VoidCallback onViewProfile;

  const InstructorInfoWidget({
    Key? key,
    required this.instructor,
    required this.onViewProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Instructor",
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructor header
                Row(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: instructor["avatar"] as String? ?? "",
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            instructor["name"] as String? ?? "",
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            instructor["credentials"] as String? ?? "",
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Instructor stats
                Row(
                  children: [
                    _buildStatItem(
                      icon: 'star',
                      value: "${instructor["rating"] ?? 0.0}",
                      label: "Rating",
                      iconColor: Colors.amber,
                    ),
                    SizedBox(width: 6.w),
                    _buildStatItem(
                      icon: 'people',
                      value: "${instructor["studentsCount"] ?? 0}",
                      label: "Students",
                      iconColor: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Instructor bio
                Text(
                  instructor["bio"] as String? ?? "",
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: 2.h),

                // View profile button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onViewProfile,
                    child: Text("View Profile"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: icon,
          color: iconColor,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
