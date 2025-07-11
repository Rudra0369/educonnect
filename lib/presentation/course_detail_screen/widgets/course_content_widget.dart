import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CourseContentWidget extends StatefulWidget {
  final List<dynamic> courseContent;

  const CourseContentWidget({
    Key? key,
    required this.courseContent,
  }) : super(key: key);

  @override
  State<CourseContentWidget> createState() => _CourseContentWidgetState();
}

class _CourseContentWidgetState extends State<CourseContentWidget> {
  final Set<int> _expandedModules = {};

  void _toggleModule(int index) {
    setState(() {
      if (_expandedModules.contains(index)) {
        _expandedModules.remove(index);
      } else {
        _expandedModules.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Course Content",
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 1.h),
          Text(
            "${widget.courseContent.length} modules • ${_getTotalLessons()} lessons • ${_getTotalDuration()}",
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          SizedBox(height: 2.h),

          // Course modules
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.courseContent.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final module =
                  widget.courseContent[index] as Map<String, dynamic>;
              final isExpanded = _expandedModules.contains(index);

              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Module header
                    InkWell(
                      onTap: () => _toggleModule(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    module["moduleTitle"] as String? ?? "",
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    "${module["lessonsCount"] ?? 0} lessons • ${module["duration"] ?? ""}",
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            CustomIconWidget(
                              iconName:
                                  isExpanded ? 'expand_less' : 'expand_more',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Module lessons (expanded)
                    if (isExpanded) ...[
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          children: [
                            ...((module["lessons"] as List?) ?? [])
                                .asMap()
                                .entries
                                .map((entry) {
                              final lessonIndex = entry.key;
                              final lesson =
                                  entry.value as Map<String, dynamic>;
                              final isCompleted =
                                  lesson["isCompleted"] as bool? ?? false;

                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: lessonIndex <
                                            ((module["lessons"] as List?)
                                                        ?.length ??
                                                    0) -
                                                1
                                        ? 2.h
                                        : 0),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: isCompleted
                                          ? 'check_circle'
                                          : 'play_circle_outline',
                                      color: isCompleted
                                          ? AppTheme
                                              .lightTheme.colorScheme.tertiary
                                          : AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                      size: 20,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        lesson["title"] as String? ?? "",
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: isCompleted
                                              ? AppTheme.lightTheme.colorScheme
                                                  .onSurfaceVariant
                                              : AppTheme.lightTheme.colorScheme
                                                  .onSurface,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      lesson["duration"] as String? ?? "",
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int _getTotalLessons() {
    int total = 0;
    for (var module in widget.courseContent) {
      final moduleMap = module as Map<String, dynamic>;
      total += (moduleMap["lessonsCount"] as int?) ?? 0;
    }
    return total;
  }

  String _getTotalDuration() {
    double totalHours = 0;
    for (var module in widget.courseContent) {
      final moduleMap = module as Map<String, dynamic>;
      final duration = moduleMap["duration"] as String? ?? "";
      final hours =
          double.tryParse(duration.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      totalHours += hours;
    }
    return "${totalHours.toStringAsFixed(1)} hours";
  }
}
