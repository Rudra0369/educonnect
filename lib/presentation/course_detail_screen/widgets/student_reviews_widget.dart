import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StudentReviewsWidget extends StatelessWidget {
  final List<dynamic> reviews;
  final double averageRating;
  final int totalReviews;

  const StudentReviewsWidget({
    Key? key,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviews header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Student Reviews",
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all reviews
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening all reviews...')),
                  );
                },
                child: Text("View All"),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Rating summary
          Row(
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: Colors.amber,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                averageRating.toStringAsFixed(1),
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                "($totalReviews reviews)",
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Reviews list
          reviews.isEmpty
              ? Container(
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
                  child: Text(
                    "No reviews yet. Be the first to review this course!",
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  height: 35.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: reviews.length,
                    separatorBuilder: (context, index) => SizedBox(width: 3.w),
                    itemBuilder: (context, index) {
                      final review = reviews[index] as Map<String, dynamic>;
                      return _buildReviewCard(review);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      width: 75.w,
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
          // Reviewer info
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
                    imageUrl: review["studentAvatar"] as String? ?? "",
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
                      review["studentName"] as String? ?? "",
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      review["date"] as String? ?? "",
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Rating stars
          Row(
            children: List.generate(5, (index) {
              final rating = (review["rating"] as num?)?.toInt() ?? 0;
              return CustomIconWidget(
                iconName: index < rating ? 'star' : 'star_border',
                color: Colors.amber,
                size: 16,
              );
            }),
          ),

          SizedBox(height: 1.h),

          // Review comment
          Expanded(
            child: Text(
              review["comment"] as String? ?? "",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 1.h),

          // Helpful votes
          Row(
            children: [
              CustomIconWidget(
                iconName: 'thumb_up',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                "Helpful (${review["helpfulVotes"] ?? 0})",
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
