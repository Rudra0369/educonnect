import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_item_widget.dart';
import './widgets/course_performance_card_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/student_query_item_widget.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;

  // Mock data for teacher dashboard
  final Map<String, dynamic> teacherData = {
    "name": "Dr. Sarah Johnson",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "totalStudents": 156,
    "activeCourses": 8,
    "completionRate": 87.5,
    "engagementScore": 92.3,
    "unreadQueries": 12,
  };

  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "type": "enrollment",
      "studentName": "Alex Chen",
      "studentAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face",
      "courseName": "Advanced Mathematics",
      "timestamp": "2 hours ago",
      "action": "enrolled in",
    },
    {
      "id": 2,
      "type": "quiz_completion",
      "studentName": "Maria Rodriguez",
      "studentAvatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face",
      "courseName": "Physics Fundamentals",
      "timestamp": "4 hours ago",
      "action": "completed quiz in",
      "score": 95,
    },
    {
      "id": 3,
      "type": "message",
      "studentName": "John Smith",
      "studentAvatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face",
      "courseName": "Chemistry Basics",
      "timestamp": "6 hours ago",
      "action": "sent message about",
    },
    {
      "id": 4,
      "type": "enrollment",
      "studentName": "Emily Davis",
      "studentAvatar":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop&crop=face",
      "courseName": "Biology Essentials",
      "timestamp": "1 day ago",
      "action": "enrolled in",
    },
  ];

  final List<Map<String, dynamic>> coursePerformance = [
    {
      "id": 1,
      "title": "Advanced Mathematics",
      "enrollments": 45,
      "averageProgress": 78.5,
      "rating": 4.8,
      "image":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=300&h=200&fit=crop",
    },
    {
      "id": 2,
      "title": "Physics Fundamentals",
      "enrollments": 38,
      "averageProgress": 82.3,
      "rating": 4.9,
      "image":
          "https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?w=300&h=200&fit=crop",
    },
    {
      "id": 3,
      "title": "Chemistry Basics",
      "enrollments": 52,
      "averageProgress": 75.2,
      "rating": 4.7,
      "image":
          "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=300&h=200&fit=crop",
    },
    {
      "id": 4,
      "title": "Biology Essentials",
      "enrollments": 21,
      "averageProgress": 89.1,
      "rating": 4.6,
      "image":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=200&fit=crop",
    },
  ];

  final List<Map<String, dynamic>> studentQueries = [
    {
      "id": 1,
      "studentName": "Alex Chen",
      "studentAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face",
      "courseName": "Advanced Mathematics",
      "question": "Can you explain the concept of derivatives in calculus?",
      "timestamp": "30 minutes ago",
      "priority": "high",
      "isAnswered": false,
    },
    {
      "id": 2,
      "studentName": "Maria Rodriguez",
      "studentAvatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face",
      "courseName": "Physics Fundamentals",
      "question": "What's the difference between velocity and acceleration?",
      "timestamp": "1 hour ago",
      "priority": "medium",
      "isAnswered": false,
    },
    {
      "id": 3,
      "studentName": "John Smith",
      "studentAvatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face",
      "courseName": "Chemistry Basics",
      "question": "How do I balance chemical equations?",
      "timestamp": "2 hours ago",
      "priority": "low",
      "isAnswered": true,
    },
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Dashboard - current screen
        break;
      case 1:
        Navigator.pushNamed(context, '/course-browse-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/student-dashboard');
        break;
      case 3:
        // Profile - navigate to profile screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              _buildHeader(),
              _buildMetricsSection(),
              _buildRecentActivitySection(),
              _buildCoursePerformanceSection(),
              _buildStudentQueriesSection(),
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    teacherData["name"] as String,
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'notifications',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                if ((teacherData["unreadQueries"] as int) > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 5.w,
                        minHeight: 5.w,
                      ),
                      child: Text(
                        '${teacherData["unreadQueries"]}',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onError,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Text(
              'Key Metrics',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: MetricsCardWidget(
                    title: 'Total Students',
                    value: '${teacherData["totalStudents"]}',
                    icon: 'people',
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: MetricsCardWidget(
                    title: 'Active Courses',
                    value: '${teacherData["activeCourses"]}',
                    icon: 'book',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: MetricsCardWidget(
                    title: 'Completion Rate',
                    value: '${teacherData["completionRate"]}%',
                    icon: 'trending_up',
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: MetricsCardWidget(
                    title: 'Engagement',
                    value: '${teacherData["engagementScore"]}%',
                    icon: 'favorite',
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            Text(
              'Recent Activity',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentActivities.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final activity = recentActivities[index];
                return ActivityItemWidget(
                  activity: activity,
                  onTap: () {
                    // Navigate to detailed view
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursePerformanceSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            Text(
              'Course Performance',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 25.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: coursePerformance.length,
                separatorBuilder: (context, index) => SizedBox(width: 3.w),
                itemBuilder: (context, index) {
                  final course = coursePerformance[index];
                  return CoursePerformanceCardWidget(
                    course: course,
                    onTap: () {
                      Navigator.pushNamed(context, '/course-detail-screen');
                    },
                    onLongPress: () {
                      _showCourseActions(course);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentQueriesSection() {
    final unansweredQueries = studentQueries
        .where((query) => !(query["isAnswered"] as bool))
        .toList();

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Student Queries',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (unansweredQueries.isNotEmpty)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${unansweredQueries.length} pending',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            unansweredQueries.isEmpty
                ? Container(
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
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'All caught up!',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'No pending student queries at the moment.',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: unansweredQueries.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final query = unansweredQueries[index];
                      return StudentQueryItemWidget(
                        query: query,
                        onTap: () {
                          // Navigate to query detail
                        },
                        onSwipeReply: () {
                          _showQuickReplyOptions(query);
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _currentIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'book',
            color: _currentIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'people',
            color: _currentIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Students',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentIndex == 3
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Navigate to course creation
      },
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 24,
      ),
      label: Text(
        'Create Course',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showCourseActions(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
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
              SizedBox(height: 3.h),
              Text(
                course["title"] as String,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              _buildActionTile(
                icon: 'analytics',
                title: 'View Analytics',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildActionTile(
                icon: 'message',
                title: 'Message Students',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildActionTile(
                icon: 'edit',
                title: 'Edit Course',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _showQuickReplyOptions(Map<String, dynamic> query) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
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
              SizedBox(height: 3.h),
              Text(
                'Quick Reply Options',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              _buildActionTile(
                icon: 'reply',
                title: 'Send Quick Reply',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildActionTile(
                icon: 'schedule',
                title: 'Schedule Response',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildActionTile(
                icon: 'forward',
                title: 'Forward to Assistant',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}
