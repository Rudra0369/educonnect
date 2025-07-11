import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CourseCardWidget extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CourseCardWidget({
    Key? key,
    required this.course,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CustomImageWidget(
                    imageUrl: course['thumbnail'] ?? '',
                    width: double.infinity,
                    height: 25.h,
                    fit: BoxFit.cover,
                  ),
                ),

                // Wishlist Icon
                Positioned(
                  top: 2.h,
                  right: 3.w,
                  child: GestureDetector(
                    onTap: () => _toggleWishlist(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: course['isWishlisted']
                            ? 'favorite'
                            : 'favorite_border',
                        color: course['isWishlisted']
                            ? Colors.red
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Free Badge
                if (course['isFree'] == true)
                  Positioned(
                    top: 2.h,
                    left: 3.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'FREE',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Difficulty Badge
                Positioned(
                  bottom: 2.h,
                  left: 3.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(course['difficulty'])
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      course['difficulty'] ?? 'Beginner',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Course Content
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Title
                  Text(
                    course['title'] ?? 'Course Title',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Instructor Name
                  Text(
                    'by ${course['instructor'] ?? 'Unknown Instructor'}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: 1.5.h),

                  // Rating and Enrollment
                  Row(
                    children: [
                      // Rating Stars
                      Row(
                        children: List.generate(5, (index) {
                          final rating = course['rating'] ?? 0.0;
                          return CustomIconWidget(
                            iconName: index < rating.floor()
                                ? 'star'
                                : (index < rating
                                    ? 'star_half'
                                    : 'star_border'),
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),

                      SizedBox(width: 2.w),

                      Text(
                        '${course['rating'] ?? 0.0}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(width: 2.w),

                      Text(
                        '(${_formatEnrollmentCount(course['enrollmentCount'] ?? 0)})',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.5.h),

                  // Duration and Category
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'access_time',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        course['duration'] ?? '0 hours',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      SizedBox(width: 4.w),
                      CustomIconWidget(
                        iconName: 'category',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          course['category'] ?? 'General',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Price and Enroll Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (course['isFree'] == true)
                            Text(
                              'Free',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else ...[
                            Text(
                              course['price'] ?? '\$0.00',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (course['originalPrice'] != null)
                              Text(
                                course['originalPrice'],
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ],
                      ),

                      // Enroll Button
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 1.h,
                          ),
                        ),
                        child: Text(
                          course['isFree'] == true
                              ? 'Enroll Free'
                              : 'Enroll Now',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
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

  Color _getDifficultyColor(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'beginner':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _formatEnrollmentCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _toggleWishlist(BuildContext context) {
    // This would typically update the course data through a state management solution
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          course['isWishlisted']
              ? 'Removed from wishlist'
              : 'Added to wishlist',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
