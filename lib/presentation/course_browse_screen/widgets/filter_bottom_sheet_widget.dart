import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final List<String> selectedCategories;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.selectedCategories,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late List<String> _tempSelectedCategories;
  String _selectedDifficulty = 'All';
  String _selectedDuration = 'All';
  RangeValues _priceRange = const RangeValues(0, 200);

  final List<String> _categories = [
    'Programming',
    'Data Science',
    'Design',
    'Marketing',
    'Photography',
    'Business',
    'Language',
    'Music',
  ];

  final List<String> _difficulties = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<String> _durations = [
    'All',
    'Under 5 hours',
    '5-20 hours',
    '20-50 hours',
    'Over 50 hours',
  ];

  @override
  void initState() {
    super.initState();
    _tempSelectedCategories = List.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Courses',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Section
                  _buildFilterSection(
                    title: 'Categories',
                    child: _buildCategoriesFilter(),
                  ),

                  SizedBox(height: 3.h),

                  // Difficulty Section
                  _buildFilterSection(
                    title: 'Difficulty Level',
                    child: _buildDifficultyFilter(),
                  ),

                  SizedBox(height: 3.h),

                  // Duration Section
                  _buildFilterSection(
                    title: 'Course Duration',
                    child: _buildDurationFilter(),
                  ),

                  SizedBox(height: 3.h),

                  // Price Range Section
                  _buildFilterSection(
                    title: 'Price Range',
                    child: _buildPriceRangeFilter(),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }

  Widget _buildCategoriesFilter() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _categories.map((category) {
        final isSelected = _tempSelectedCategories.contains(category);
        return GestureDetector(
          onTap: () => _toggleCategory(category),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Text(
              category,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDifficultyFilter() {
    return Column(
      children: _difficulties.map((difficulty) {
        return RadioListTile<String>(
          title: Text(
            difficulty,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          value: difficulty,
          groupValue: _selectedDifficulty,
          onChanged: (value) {
            setState(() {
              _selectedDifficulty = value ?? 'All';
            });
          },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildDurationFilter() {
    return Column(
      children: _durations.map((duration) {
        return RadioListTile<String>(
          title: Text(
            duration,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          value: duration,
          groupValue: _selectedDuration,
          onChanged: (value) {
            setState(() {
              _selectedDuration = value ?? 'All';
            });
          },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_priceRange.start.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '\$${_priceRange.end.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 500,
          divisions: 50,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: Text(
                  'Include Free Courses',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                value: _priceRange.start == 0,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _priceRange = RangeValues(0, _priceRange.end);
                    } else {
                      _priceRange = RangeValues(1, _priceRange.end);
                    }
                  });
                },
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_tempSelectedCategories.contains(category)) {
        _tempSelectedCategories.remove(category);
      } else {
        _tempSelectedCategories.add(category);
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      _tempSelectedCategories.clear();
      _selectedDifficulty = 'All';
      _selectedDuration = 'All';
      _priceRange = const RangeValues(0, 200);
    });
  }

  void _applyFilters() {
    final filters = {
      'categories': _tempSelectedCategories,
      'difficulty': _selectedDifficulty,
      'duration': _selectedDuration,
      'priceRange': _priceRange,
    };

    widget.onFiltersApplied(filters);
    Navigator.pop(context);
  }
}
