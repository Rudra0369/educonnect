import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/quiz_screen/quiz_screen.dart';
import '../presentation/teacher_dashboard/teacher_dashboard.dart';
import '../presentation/course_detail_screen/course_detail_screen.dart';
import '../presentation/course_browse_screen/course_browse_screen.dart';
import '../presentation/student_dashboard/student_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String quizScreen = '/quiz-screen';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String courseDetailScreen = '/course-detail-screen';
  static const String courseBrowseScreen = '/course-browse-screen';
  static const String studentDashboard = '/student-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => LoginScreen(),
    loginScreen: (context) => LoginScreen(),
    quizScreen: (context) => QuizScreen(),
    teacherDashboard: (context) => TeacherDashboard(),
    courseDetailScreen: (context) => CourseDetailScreen(),
    courseBrowseScreen: (context) => CourseBrowseScreen(),
    studentDashboard: (context) => StudentDashboard(),
    // TODO: Add your other routes here
  };
}
