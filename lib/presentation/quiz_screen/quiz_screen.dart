import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/answer_option_widget.dart';
import './widgets/navigation_buttons_widget.dart';
import './widgets/question_card_widget.dart';
import './widgets/quiz_progress_widget.dart';
import './widgets/quiz_timer_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  int _currentQuestionIndex = 0;
  int _timeRemaining = 1800; // 30 minutes in seconds
  bool _isTimerActive = true;
  Map<int, dynamic> _selectedAnswers = {};
  Set<int> _bookmarkedQuestions = {};
  bool _isReviewMode = false;
  bool _showResults = false;

  // Mock quiz data
  final List<Map<String, dynamic>> _quizData = [
    {
      "id": 1,
      "type": "multiple_choice",
      "question": "What is the primary purpose of Flutter's StatefulWidget?",
      "description":
          "Choose the most accurate description of StatefulWidget's main functionality in Flutter applications.",
      "image": null,
      "options": [
        {
          "id": "a",
          "text": "To create widgets that never change their appearance",
          "isCorrect": false
        },
        {
          "id": "b",
          "text": "To manage and update widget state that can change over time",
          "isCorrect": true
        },
        {
          "id": "c",
          "text": "To handle network requests exclusively",
          "isCorrect": false
        },
        {"id": "d", "text": "To create static layouts only", "isCorrect": false}
      ],
      "explanation":
          "StatefulWidget is designed to manage mutable state that can change during the widget's lifetime, triggering UI rebuilds when setState() is called.",
      "points": 2,
      "difficulty": "medium"
    },
    {
      "id": 2,
      "type": "true_false",
      "question":
          "Flutter applications can run on both iOS and Android platforms using the same codebase.",
      "description":
          "Determine if this statement about Flutter's cross-platform capabilities is true or false.",
      "image": null,
      "options": [
        {"id": "true", "text": "True", "isCorrect": true},
        {"id": "false", "text": "False", "isCorrect": false}
      ],
      "explanation":
          "Flutter is a cross-platform framework that allows developers to write code once and deploy it on multiple platforms including iOS, Android, web, and desktop.",
      "points": 1,
      "difficulty": "easy"
    },
    {
      "id": 3,
      "type": "multiple_select",
      "question":
          "Which of the following are valid Flutter widget lifecycle methods?",
      "description":
          "Select all methods that are part of the StatefulWidget lifecycle in Flutter.",
      "image": null,
      "options": [
        {"id": "a", "text": "initState()", "isCorrect": true},
        {"id": "b", "text": "dispose()", "isCorrect": true},
        {"id": "c", "text": "onCreate()", "isCorrect": false},
        {"id": "d", "text": "build()", "isCorrect": true},
        {"id": "e", "text": "onDestroy()", "isCorrect": false}
      ],
      "explanation":
          "initState(), dispose(), and build() are core lifecycle methods in Flutter StatefulWidget. onCreate() and onDestroy() are Android Activity methods.",
      "points": 3,
      "difficulty": "hard"
    },
    {
      "id": 4,
      "type": "fill_blank",
      "question":
          "Complete the code: Widget build(BuildContext ______) { return Container(); }",
      "description":
          "Fill in the missing parameter name in the build method signature.",
      "image": null,
      "correctAnswer": "context",
      "explanation":
          "The build method takes a BuildContext parameter named 'context' which provides information about the widget's location in the widget tree.",
      "points": 2,
      "difficulty": "medium"
    },
    {
      "id": 5,
      "type": "multiple_choice",
      "question":
          "What is the recommended way to handle asynchronous operations in Flutter?",
      "description":
          "Choose the best practice for managing async operations in Flutter applications.",
      "image": null,
      "options": [
        {
          "id": "a",
          "text": "Using Timer.periodic() for all async operations",
          "isCorrect": false
        },
        {
          "id": "b",
          "text":
              "Using Future and async/await patterns with proper error handling",
          "isCorrect": true
        },
        {
          "id": "c",
          "text": "Blocking the main thread until operations complete",
          "isCorrect": false
        },
        {
          "id": "d",
          "text": "Using only synchronous operations",
          "isCorrect": false
        }
      ],
      "explanation":
          "Flutter recommends using Future and async/await patterns with proper error handling using try-catch blocks for asynchronous operations.",
      "points": 2,
      "difficulty": "medium"
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isTimerActive) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _timeRemaining > 0 && _isTimerActive) {
          setState(() {
            _timeRemaining--;
          });
          _startTimer();
        } else if (_timeRemaining == 0) {
          _submitQuiz();
        }
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _quizData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showSubmitDialog();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _selectAnswer(dynamic answer) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _toggleBookmark() {
    HapticFeedback.lightImpact();
    setState(() {
      if (_bookmarkedQuestions.contains(_currentQuestionIndex)) {
        _bookmarkedQuestions.remove(_currentQuestionIndex);
      } else {
        _bookmarkedQuestions.add(_currentQuestionIndex);
      }
    });
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Submit Quiz',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to submit your quiz? You have answered ${_selectedAnswers.length} out of ${_quizData.length} questions.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Review'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitQuiz();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitQuiz() {
    setState(() {
      _isTimerActive = false;
      _showResults = true;
    });
  }

  void _retakeQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedAnswers.clear();
      _bookmarkedQuestions.clear();
      _timeRemaining = 1800;
      _isTimerActive = true;
      _showResults = false;
      _isReviewMode = false;
    });
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _startTimer();
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < _quizData.length; i++) {
      final question = _quizData[i];
      final selectedAnswer = _selectedAnswers[i];

      if (selectedAnswer != null) {
        if (question['type'] == 'multiple_choice' ||
            question['type'] == 'true_false') {
          final correctOption = (question['options'] as List).firstWhere(
            (option) => option['isCorrect'] == true,
            orElse: () => null,
          );
          if (correctOption != null && selectedAnswer == correctOption['id']) {
            score += question['points'] as int;
          }
        } else if (question['type'] == 'multiple_select') {
          final correctOptions = (question['options'] as List)
              .where((option) => option['isCorrect'] == true)
              .map((option) => option['id'])
              .toSet();
          final selectedOptions = Set<String>.from(selectedAnswer as List);
          if (correctOptions.length == selectedOptions.length &&
              correctOptions
                  .every((option) => selectedOptions.contains(option))) {
            score += question['points'] as int;
          }
        } else if (question['type'] == 'fill_blank') {
          if (selectedAnswer.toString().toLowerCase().trim() ==
              question['correctAnswer'].toString().toLowerCase().trim()) {
            score += question['points'] as int;
          }
        }
      }
    }
    return score;
  }

  int _getTotalPoints() {
    return _quizData.fold(
        0, (sum, question) => sum + (question['points'] as int));
  }

  Widget _buildResultsScreen() {
    final score = _calculateScore();
    final totalPoints = _getTotalPoints();
    final percentage = (score / totalPoints * 100).round();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Quiz Results'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/student-dashboard'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.w),
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
                children: [
                  CustomIconWidget(
                    iconName: percentage >= 70 ? 'check_circle' : 'cancel',
                    color: percentage >= 70
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : AppTheme.lightTheme.colorScheme.error,
                    size: 64,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    percentage >= 70 ? 'Congratulations!' : 'Keep Learning!',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: percentage >= 70
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Your Score: $score/$totalPoints ($percentage%)',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 2.h),
                  LinearProgressIndicator(
                    value: score / totalPoints,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentage >= 70
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Summary',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Questions Answered:',
                          style: AppTheme.lightTheme.textTheme.bodyMedium),
                      Text('${_selectedAnswers.length}/${_quizData.length}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Time Taken:',
                          style: AppTheme.lightTheme.textTheme.bodyMedium),
                      Text(
                          '${((1800 - _timeRemaining) / 60).floor()}:${((1800 - _timeRemaining) % 60).toString().padLeft(2, '0')}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bookmarked Questions:',
                          style: AppTheme.lightTheme.textTheme.bodyMedium),
                      Text('${_bookmarkedQuestions.length}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _retakeQuiz,
                    child: const Text('Retake Quiz'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, '/student-dashboard'),
                    child: const Text('Continue Learning'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return _buildResultsScreen();
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Flutter Fundamentals Quiz'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _bookmarkedQuestions.contains(_currentQuestionIndex)
                  ? 'bookmark'
                  : 'bookmark_border',
              color: _bookmarkedQuestions.contains(_currentQuestionIndex)
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            QuizProgressWidget(
              currentQuestion: _currentQuestionIndex + 1,
              totalQuestions: _quizData.length,
              progress: (_currentQuestionIndex + 1) / _quizData.length,
            ),
            if (_isTimerActive) QuizTimerWidget(timeRemaining: _timeRemaining),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentQuestionIndex = index;
                  });
                },
                itemCount: _quizData.length,
                itemBuilder: (context, index) {
                  final question = _quizData[index];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuestionCardWidget(
                          question: question,
                          questionNumber: index + 1,
                        ),
                        SizedBox(height: 3.h),
                        AnswerOptionWidget(
                          question: question,
                          selectedAnswer: _selectedAnswers[index],
                          onAnswerSelected: _selectAnswer,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            NavigationButtonsWidget(
              currentIndex: _currentQuestionIndex,
              totalQuestions: _quizData.length,
              hasAnswer: _selectedAnswers.containsKey(_currentQuestionIndex),
              onPrevious: _previousQuestion,
              onNext: _nextQuestion,
              onSubmit: _showSubmitDialog,
            ),
          ],
        ),
      ),
    );
  }
}
