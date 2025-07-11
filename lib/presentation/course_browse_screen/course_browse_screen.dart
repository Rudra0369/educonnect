import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_chip_widget.dart';
import './widgets/course_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';

class CourseBrowseScreen extends StatefulWidget {
  const CourseBrowseScreen({Key? key}) : super(key: key);

  @override
  State<CourseBrowseScreen> createState() => _CourseBrowseScreenState();
}

class _CourseBrowseScreenState extends State<CourseBrowseScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isSearching = false;
  List<String> _selectedCategories = [];
  List<String> _recentSearches = [
    'Flutter Development',
    'Data Science',
    'UI/UX Design'
  ];

  // Mock data for courses
  final List<Map<String, dynamic>> _allCourses = [
    {
      "id": 1,
      "title": "Complete Flutter Development Bootcamp",
      "instructor": "Dr. Angela Yu",
      "category": "Programming",
      "difficulty": "Beginner",
      "duration": "65 hours",
      "price": "\$89.99",
      "originalPrice": "\$199.99",
      "rating": 4.8,
      "enrollmentCount": 45230,
      "thumbnail":
          "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFree": false,
      "isWishlisted": false,
      "tags": ["Flutter", "Mobile Development", "Dart"],
      "lastUpdated": "2025-07-10"
    },
    {
      "id": 2,
      "title": "Data Science and Machine Learning with Python",
      "instructor": "Jose Marcial Portilla",
      "category": "Data Science",
      "difficulty": "Intermediate",
      "duration": "42 hours",
      "price": "Free",
      "originalPrice": null,
      "rating": 4.6,
      "enrollmentCount": 28450,
      "thumbnail":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFree": true,
      "isWishlisted": true,
      "tags": ["Python", "Machine Learning", "Data Analysis"],
      "lastUpdated": "2025-07-09"
    },
    {
      "id": 3,
      "title": "UI/UX Design Fundamentals",
      "instructor": "Sarah Johnson",
      "category": "Design",
      "difficulty": "Beginner",
      "duration": "28 hours",
      "price": "\$49.99",
      "originalPrice": "\$99.99",
      "rating": 4.9,
      "enrollmentCount": 15670,
      "thumbnail":
          "https://images.unsplash.com/photo-1561070791-2526d30994b5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFree": false,
      "isWishlisted": false,
      "tags": ["UI Design", "UX Research", "Figma"],
      "lastUpdated": "2025-07-08"
    },
    {
      "id": 4,
      "title": "Advanced React Native Development",
      "instructor": "Stephen Grider",
      "category": "Programming",
      "difficulty": "Advanced",
      "duration": "38 hours",
      "price": "\$79.99",
      "originalPrice": "\$149.99",
      "rating": 4.7,
      "enrollmentCount": 12340,
      "thumbnail":
          "https://images.unsplash.com/photo-1555066931-4365d14bab8c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFree": false,
      "isWishlisted": true,
      "tags": ["React Native", "JavaScript", "Mobile Apps"],
      "lastUpdated": "2025-07-07"
    },
    {
      "id": 5,
      "title": "Digital Marketing Masterclass",
      "instructor": "Neil Patel",
      "category": "Marketing",
      "difficulty": "Intermediate",
      "duration": "32 hours",
      "price": "\$59.99",
      "originalPrice": "\$119.99",
      "rating": 4.5,
      "enrollmentCount": 23450,
      "thumbnail":
          "https://images.unsplash.com/photo-1460925895917-afdab827c52f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFree": false,
      "isWishlisted": false,
      "tags": ["SEO", "Social Media", "Analytics"],
      "lastUpdated": "2025-07-06"
    },
    {
      "id": 6,
      "title": "Photography for Beginners",
      "instructor": "Peter McKinnon",
      "category": "Photography",
      "difficulty": "Beginner",
      "duration": "18 hours",
      "price": "Free",
      "originalPrice": null,
      "rating": 4.8,
      "enrollmentCount": 34560,
      "thumbnail":
          "https://images.unsplash.com/photo-1502920917128-1aa500764cbd?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFree": true,
      "isWishlisted": false,
      "tags": ["Photography", "Composition", "Lighting"],
      "lastUpdated": "2025-07-05"
    }
  ];

  List<Map<String, dynamic>> _filteredCourses = [];

  final List<String> _categories = [
    'All',
    'Programming',
    'Data Science',
    'Design',
    'Marketing',
    'Photography',
    'Business'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _filteredCourses = List.from(_allCourses);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreCourses();
    }
  }

  void _loadMoreCourses() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCourses = _applyFilters(_allCourses);
        _isSearching = false;
      } else {
        _isSearching = true;
        _filteredCourses = _allCourses
            .where((course) =>
                (course['title'] as String)
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (course['instructor'] as String)
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (course['tags'] as List).any(
                    (tag) => tag.toLowerCase().contains(query.toLowerCase())))
            .toList();
        _filteredCourses = _applyFilters(_filteredCourses);
      }
    });
  }

  List<Map<String, dynamic>> _applyFilters(List<Map<String, dynamic>> courses) {
    if (_selectedCategories.isEmpty || _selectedCategories.contains('All')) {
      return courses;
    }

    return courses
        .where((course) => _selectedCategories.contains(course['category']))
        .toList();
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (category == 'All') {
        _selectedCategories.clear();
      } else {
        if (_selectedCategories.contains(category)) {
          _selectedCategories.remove(category);
        } else {
          _selectedCategories.add(category);
        }
      }
      _filteredCourses = _applyFilters(_allCourses);
    });
  }

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedCategories: _selectedCategories,
        onFiltersApplied: (filters) {
          setState(() {
            _selectedCategories = filters['categories'] ?? [];
            _filteredCourses = _applyFilters(_allCourses);
          });
        },
      ),
    );
  }

  void _onCoursePressed(Map<String, dynamic> course) {
    Navigator.pushNamed(context, '/course-detail-screen', arguments: course);
  }

  void _onCourseLongPressed(Map<String, dynamic> course) {
    _showCourseActions(course);
  }

  void _showCourseActions(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              course['title'],
              style: AppTheme.lightTheme.textTheme.titleMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 3.h),
            _buildActionTile(
              icon: course['isWishlisted'] ? 'favorite' : 'favorite_border',
              title: course['isWishlisted']
                  ? 'Remove from Wishlist'
                  : 'Add to Wishlist',
              onTap: () {
                Navigator.pop(context);
                _toggleWishlist(course);
              },
            ),
            _buildActionTile(
              icon: 'share',
              title: 'Share Course',
              onTap: () {
                Navigator.pop(context);
                _shareCourse(course);
              },
            ),
            _buildActionTile(
              icon: 'person',
              title: 'View Instructor Profile',
              onTap: () {
                Navigator.pop(context);
                _viewInstructorProfile(course);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
    );
  }

  void _toggleWishlist(Map<String, dynamic> course) {
    setState(() {
      course['isWishlisted'] = !course['isWishlisted'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          course['isWishlisted']
              ? 'Added to wishlist'
              : 'Removed from wishlist',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareCourse(Map<String, dynamic> course) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${course['title']}"'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _viewInstructorProfile(Map<String, dynamic> course) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${course['instructor']} profile'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _filteredCourses = _applyFilters(_allCourses);
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _searchController.clear();
      _filteredCourses = List.from(_allCourses);
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      Navigator.pushReplacementNamed(
                          context, '/student-dashboard');
                      break;
                    case 1:
                      // Current screen - Courses
                      break;
                    case 2:
                      // Messages - would navigate to messages screen
                      break;
                    case 3:
                      // Profile - would navigate to profile screen
                      break;
                  }
                },
                tabs: [
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'dashboard',
                      color: _tabController.index == 0
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Dashboard',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'school',
                      color: _tabController.index == 1
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Courses',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'message',
                      color: _tabController.index == 2
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Messages',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'person',
                      color: _tabController.index == 3
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Profile',
                  ),
                ],
              ),
            ),

            // Search Header
            Container(
              padding: EdgeInsets.all(4.w),
              color: AppTheme.lightTheme.colorScheme.surface,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Search courses...',
                              prefixIcon: CustomIconWidget(
                                iconName: 'search',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        _onSearchChanged('');
                                      },
                                      child: CustomIconWidget(
                                        iconName: 'clear',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 20,
                                      ),
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 2.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      GestureDetector(
                        onTap: _onFilterPressed,
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: _selectedCategories.isNotEmpty
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'tune',
                            color: _selectedCategories.isNotEmpty
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Recent searches (when searching)
                  if (_isSearching &&
                      _searchController.text.isEmpty &&
                      _recentSearches.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recent Searches',
                        style: AppTheme.lightTheme.textTheme.labelMedium,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _recentSearches
                          .map((search) => GestureDetector(
                                onTap: () {
                                  _searchController.text = search;
                                  _onSearchChanged(search);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 1.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.outline,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'history',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 16,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        search,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Category Filters
            if (_selectedCategories.isNotEmpty) ...[
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedCategories.length + 1,
                  separatorBuilder: (context, index) => SizedBox(width: 2.w),
                  itemBuilder: (context, index) {
                    if (index == _selectedCategories.length) {
                      return CategoryChipWidget(
                        label: 'Clear All',
                        isSelected: false,
                        onTap: _clearFilters,
                        showClose: false,
                      );
                    }

                    final category = _selectedCategories[index];
                    final count = _allCourses
                        .where((course) => course['category'] == category)
                        .length;

                    return CategoryChipWidget(
                      label: '$category ($count)',
                      isSelected: true,
                      onTap: () => _onCategorySelected(category),
                      showClose: true,
                    );
                  },
                ),
              ),
              SizedBox(height: 1.h),
            ],

            // Course List
            Expanded(
              child: _filteredCourses.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.all(4.w),
                        itemCount:
                            _filteredCourses.length + (_isLoading ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 2.h),
                        itemBuilder: (context, index) {
                          if (index == _filteredCourses.length) {
                            return _buildLoadingIndicator();
                          }

                          final course = _filteredCourses[index];
                          return CourseCardWidget(
                            course: course,
                            onTap: () => _onCoursePressed(course),
                            onLongPress: () => _onCourseLongPressed(course),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No courses found',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters to find what you\'re looking for.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _clearFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }
}
