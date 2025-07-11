import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/course_content_widget.dart';
import './widgets/course_hero_widget.dart';
import './widgets/course_includes_widget.dart';
import './widgets/enrollment_button_widget.dart';
import './widgets/instructor_info_widget.dart';
import './widgets/student_reviews_widget.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isDescriptionExpanded = false;
  bool _isLoading = false;

  // Mock course data
  final Map<String, dynamic> courseData = {
    "id": 1,
    "title": "Complete Flutter Development Bootcamp",
    "description":
        """Master Flutter development from scratch with this comprehensive bootcamp. Learn to build beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. This course covers everything from basic Dart programming to advanced Flutter concepts including state management, animations, and deployment strategies. You'll work on real-world projects and build a portfolio of applications that demonstrate your skills to potential employers.""",
    "shortDescription":
        "Master Flutter development from scratch with this comprehensive bootcamp covering mobile, web, and desktop development.",
    "thumbnail":
        "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "previewVideoUrl":
        "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
    "instructor": {
      "id": 1,
      "name": "Dr. Sarah Johnson",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "bio":
          "Senior Flutter Developer with 8+ years of experience in mobile app development. Former Google engineer and Flutter team contributor.",
      "credentials":
          "PhD in Computer Science, Google Certified Flutter Developer",
      "rating": 4.9,
      "studentsCount": 15420
    },
    "rating": 4.8,
    "reviewsCount": 2847,
    "studentsEnrolled": 12450,
    "price": "\$89.99",
    "originalPrice": "\$149.99",
    "duration": "42 hours",
    "lessonsCount": 156,
    "level": "Beginner to Advanced",
    "language": "English",
    "lastUpdated": "December 2024",
    "enrollmentStatus": "not_enrolled", // not_enrolled, enrolled, completed
    "whatYouLearn": [
      "Build complete Flutter applications from scratch",
      "Master Dart programming language fundamentals",
      "Implement state management with Provider and Bloc",
      "Create responsive UI designs for multiple screen sizes",
      "Integrate REST APIs and handle data persistence",
      "Deploy apps to Google Play Store and Apple App Store",
      "Implement advanced animations and custom widgets",
      "Handle user authentication and security best practices"
    ],
    "courseContent": [
      {
        "moduleTitle": "Getting Started with Flutter",
        "lessonsCount": 12,
        "duration": "3.5 hours",
        "lessons": [
          {
            "title": "Introduction to Flutter",
            "duration": "15 min",
            "isCompleted": false
          },
          {
            "title": "Setting up Development Environment",
            "duration": "25 min",
            "isCompleted": false
          },
          {
            "title": "Your First Flutter App",
            "duration": "30 min",
            "isCompleted": false
          }
        ]
      },
      {
        "moduleTitle": "Dart Programming Fundamentals",
        "lessonsCount": 18,
        "duration": "5.2 hours",
        "lessons": [
          {
            "title": "Variables and Data Types",
            "duration": "20 min",
            "isCompleted": false
          },
          {
            "title": "Functions and Classes",
            "duration": "35 min",
            "isCompleted": false
          },
          {
            "title": "Object-Oriented Programming",
            "duration": "40 min",
            "isCompleted": false
          }
        ]
      },
      {
        "moduleTitle": "Building User Interfaces",
        "lessonsCount": 24,
        "duration": "8.1 hours",
        "lessons": [
          {
            "title": "Understanding Widgets",
            "duration": "25 min",
            "isCompleted": false
          },
          {
            "title": "Layout Widgets and Positioning",
            "duration": "45 min",
            "isCompleted": false
          },
          {
            "title": "Styling and Theming",
            "duration": "30 min",
            "isCompleted": false
          }
        ]
      },
      {
        "moduleTitle": "State Management",
        "lessonsCount": 20,
        "duration": "6.8 hours",
        "lessons": [
          {
            "title": "StatefulWidget vs StatelessWidget",
            "duration": "20 min",
            "isCompleted": false
          },
          {
            "title": "Provider State Management",
            "duration": "50 min",
            "isCompleted": false
          },
          {
            "title": "Bloc Pattern Implementation",
            "duration": "60 min",
            "isCompleted": false
          }
        ]
      }
    ],
    "reviews": [
      {
        "id": 1,
        "studentName": "Michael Chen",
        "studentAvatar":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "rating": 5,
        "comment":
            "Excellent course! The instructor explains complex concepts in a very clear and understandable way. The hands-on projects really helped me grasp Flutter development.",
        "date": "2024-12-05",
        "helpfulVotes": 24
      },
      {
        "id": 2,
        "studentName": "Emily Rodriguez",
        "studentAvatar":
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "rating": 5,
        "comment":
            "This course exceeded my expectations. I went from knowing nothing about Flutter to building my own apps. Highly recommended for beginners!",
        "date": "2024-11-28",
        "helpfulVotes": 18
      },
      {
        "id": 3,
        "studentName": "David Kim",
        "studentAvatar":
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "rating": 4,
        "comment":
            "Great content and well-structured curriculum. The only minor issue is that some videos could be updated to reflect the latest Flutter version.",
        "date": "2024-11-15",
        "helpfulVotes": 12
      }
    ],
    "courseIncludes": [
      {"icon": "play_circle_outline", "title": "42 hours on-demand video"},
      {"icon": "article", "title": "15 downloadable resources"},
      {"icon": "phone_android", "title": "Access on mobile and desktop"},
      {"icon": "all_inclusive", "title": "Full lifetime access"},
      {"icon": "card_membership", "title": "Certificate of completion"},
      {"icon": "cloud_download", "title": "Offline viewing capability"}
    ]
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleDescription() {
    setState(() {
      _isDescriptionExpanded = !_isDescriptionExpanded;
    });
  }

  void _handleEnrollment() {
    setState(() {
      _isLoading = true;
    });

    // Simulate enrollment process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        courseData["enrollmentStatus"] = "enrolled";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully enrolled in ${courseData["title"]}!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    });
  }

  void _shareContent() {
    // Platform-native sharing implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Course link copied to clipboard!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar with course title
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                pinned: true,
                backgroundColor:
                    AppTheme.lightTheme.appBarTheme.backgroundColor,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                title: Text(
                  courseData["title"] ?? "Course Details",
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                actions: [
                  IconButton(
                    onPressed: _shareContent,
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),

              // Course content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero section
                    CourseHeroWidget(
                      courseData: courseData,
                      onPlayPreview: () {
                        // Video preview implementation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Playing preview video...')),
                        );
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Course description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About this course",
                            style: AppTheme.lightTheme.textTheme.titleLarge,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _isDescriptionExpanded
                                ? courseData["description"] ?? ""
                                : courseData["shortDescription"] ?? "",
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 1.h),
                          GestureDetector(
                            onTap: _toggleDescription,
                            child: Text(
                              _isDescriptionExpanded
                                  ? "Read Less"
                                  : "Read More",
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // What you'll learn section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What you'll learn",
                            style: AppTheme.lightTheme.textTheme.titleLarge,
                          ),
                          SizedBox(height: 2.h),
                          ...((courseData["whatYouLearn"] as List?) ?? [])
                              .map(
                                (item) => Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'check_circle',
                                        color: AppTheme
                                            .lightTheme.colorScheme.tertiary,
                                        size: 20,
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Text(
                                          item.toString(),
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Course content
                    CourseContentWidget(
                      courseContent:
                          (courseData["courseContent"] as List?) ?? [],
                    ),

                    SizedBox(height: 3.h),

                    // Instructor info
                    InstructorInfoWidget(
                      instructor:
                          courseData["instructor"] as Map<String, dynamic>? ??
                              {},
                      onViewProfile: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Opening instructor profile...')),
                        );
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Student reviews
                    StudentReviewsWidget(
                      reviews: (courseData["reviews"] as List?) ?? [],
                      averageRating:
                          (courseData["rating"] as num?)?.toDouble() ?? 0.0,
                      totalReviews: courseData["reviewsCount"] as int? ?? 0,
                    ),

                    SizedBox(height: 3.h),

                    // Course includes
                    CourseIncludesWidget(
                      courseIncludes:
                          (courseData["courseIncludes"] as List?) ?? [],
                    ),

                    // Bottom padding for floating button
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),

          // Floating enrollment button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: EnrollmentButtonWidget(
              enrollmentStatus:
                  courseData["enrollmentStatus"] as String? ?? "not_enrolled",
              price: courseData["price"] as String? ?? "",
              originalPrice: courseData["originalPrice"] as String? ?? "",
              isLoading: _isLoading,
              onEnroll: _handleEnrollment,
              onContinue: () {
                Navigator.pushNamed(context, '/student-dashboard');
              },
            ),
          ),
        ],
      ),
    );
  }
}
