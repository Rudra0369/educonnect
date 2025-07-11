import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/continue_learning_card_widget.dart';
import './widgets/progress_summary_card_widget.dart';
import './widgets/recent_message_item_widget.dart';
import './widgets/upcoming_deadline_item_widget.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isRefreshing = false;

  // Mock data for the dashboard
  final Map<String, dynamic> studentData = {
    "name": "Alex Johnson",
    "completionPercentage": 68,
    "learningStreak": 12,
    "weeklyGoals": 5,
    "weeklyCompleted": 3,
    "unreadMessages": 3,
  };

  final List<Map<String, dynamic>> continueLearningSections = [
    {
      "id": 1,
      "title": "Advanced Mathematics",
      "thumbnail":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "progress": 0.75,
      "timeRemaining": "2h 30m left",
      "lastAccessed": "2 hours ago",
    },
    {
      "id": 2,
      "title": "Physics Fundamentals",
      "thumbnail":
          "https://images.pexels.com/photos/220301/pexels-photo-220301.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "progress": 0.45,
      "timeRemaining": "4h 15m left",
      "lastAccessed": "1 day ago",
    },
    {
      "id": 3,
      "title": "Chemistry Basics",
      "thumbnail":
          "https://cdn.pixabay.com/photo/2017/07/18/15/39/school-2515394_1280.jpg",
      "progress": 0.30,
      "timeRemaining": "6h 45m left",
      "lastAccessed": "3 days ago",
    },
  ];

  final List<Map<String, dynamic>> upcomingDeadlines = [
    {
      "id": 1,
      "courseName": "Advanced Mathematics",
      "taskType": "Assignment",
      "taskTitle": "Calculus Problem Set",
      "dueDate": DateTime.now().add(Duration(days: 2)),
      "isCompleted": false,
    },
    {
      "id": 2,
      "courseName": "Physics Fundamentals",
      "taskType": "Quiz",
      "taskTitle": "Motion and Forces",
      "dueDate": DateTime.now().add(Duration(days: 5)),
      "isCompleted": false,
    },
    {
      "id": 3,
      "courseName": "Chemistry Basics",
      "taskType": "Lab Report",
      "taskTitle": "Chemical Reactions",
      "dueDate": DateTime.now().add(Duration(days: 7)),
      "isCompleted": false,
    },
  ];

  final List<Map<String, dynamic>> recentMessages = [
    {
      "id": 1,
      "senderName": "Dr. Sarah Wilson",
      "courseName": "Advanced Mathematics",
      "message":
          "Great work on your latest assignment! I've added some additional resources for the next chapter.",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "isRead": false,
      "senderAvatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "senderName": "Prof. Michael Chen",
      "courseName": "Physics Fundamentals",
      "message":
          "Don't forget about the upcoming quiz on motion and forces. Review chapters 3-5.",
      "timestamp": DateTime.now().subtract(Duration(hours: 6)),
      "isRead": false,
      "senderAvatar":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 3,
      "senderName": "Dr. Emily Rodriguez",
      "courseName": "Chemistry Basics",
      "message":
          "Lab session has been rescheduled to next Tuesday. Please check the updated materials.",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "isRead": true,
      "senderAvatar":
          "https://cdn.pixabay.com/photo/2017/06/26/02/47/man-2442565_1280.jpg",
    },
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dashboard updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _markDeadlineComplete(int deadlineId) {
    setState(() {
      final deadline = upcomingDeadlines.firstWhere(
        (deadline) => (deadline["id"] as int) == deadlineId,
        orElse: () => <String, dynamic>{},
      );
      if (deadline.isNotEmpty) {
        deadline["isCompleted"] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task marked as complete!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToCourse(int courseId) {
    Navigator.pushNamed(context, '/course-detail-screen');
  }

  void _navigateToMessages() {
    // Navigate to messages screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Messages feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToBrowseCourses() {
    Navigator.pushNamed(context, '/course-browse-screen');
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
              // Header Section
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good morning,',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              studentData["name"] as String,
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
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
                              size: 6.w,
                            ),
                          ),
                          if ((studentData["unreadMessages"] as int) > 0)
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
                                  '${studentData["unreadMessages"]}',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.onError,
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
              ),

              // Progress Summary Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ProgressSummaryCardWidget(
                    completionPercentage:
                        studentData["completionPercentage"] as int,
                    learningStreak: studentData["learningStreak"] as int,
                    weeklyGoals: studentData["weeklyGoals"] as int,
                    weeklyCompleted: studentData["weeklyCompleted"] as int,
                  ),
                ),
              ),

              SizedBox(height: 2.h).sliver,

              // Continue Learning Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Continue Learning',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: _navigateToBrowseCourses,
                        child: Text('View All'),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  height: 25.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: continueLearningSections.length,
                    itemBuilder: (context, index) {
                      final course = continueLearningSections[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: ContinueLearningCardWidget(
                          title: course["title"] as String,
                          thumbnail: course["thumbnail"] as String,
                          progress: course["progress"] as double,
                          timeRemaining: course["timeRemaining"] as String,
                          lastAccessed: course["lastAccessed"] as String,
                          onTap: () => _navigateToCourse(course["id"] as int),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 3.h).sliver,

              // Upcoming Deadlines Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'Upcoming Deadlines',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 1.h).sliver,

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final deadline = upcomingDeadlines[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 0.5.h),
                      child: UpcomingDeadlineItemWidget(
                        courseName: deadline["courseName"] as String,
                        taskType: deadline["taskType"] as String,
                        taskTitle: deadline["taskTitle"] as String,
                        dueDate: deadline["dueDate"] as DateTime,
                        isCompleted: deadline["isCompleted"] as bool,
                        onMarkComplete: () =>
                            _markDeadlineComplete(deadline["id"] as int),
                      ),
                    );
                  },
                  childCount: upcomingDeadlines.length,
                ),
              ),

              SizedBox(height: 3.h).sliver,

              // Recent Messages Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Messages',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: _navigateToMessages,
                        child: Text('View All'),
                      ),
                    ],
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final message = recentMessages[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 0.5.h),
                      child: RecentMessageItemWidget(
                        senderName: message["senderName"] as String,
                        courseName: message["courseName"] as String,
                        message: message["message"] as String,
                        timestamp: message["timestamp"] as DateTime,
                        isRead: message["isRead"] as bool,
                        senderAvatar: message["senderAvatar"] as String,
                        onTap: _navigateToMessages,
                      ),
                    );
                  },
                  childCount: recentMessages.length,
                ),
              ),

              SizedBox(height: 10.h).sliver,
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              // Already on Dashboard
              break;
            case 1:
              _navigateToBrowseCourses();
              break;
            case 2:
              _navigateToMessages();
              break;
            case 3:
              // Navigate to profile
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'school',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'message',
                  color: _currentIndex == 2
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                if ((studentData["unreadMessages"] as int) > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(0.5.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 3.w,
                        minHeight: 3.w,
                      ),
                      child: Text(
                        '${studentData["unreadMessages"]}',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onError,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToBrowseCourses,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'explore',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 5.w,
        ),
        label: Text(
          'Browse Courses',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

extension SliverBoxAdapter on SizedBox {
  Widget get sliver => SliverToBoxAdapter(child: this);
}
