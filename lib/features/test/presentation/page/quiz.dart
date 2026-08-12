import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import '../../../../core/constants/app_colors.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  static const String routeName = '/quiz-panel';

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: 'What is the primary language used for Flutter development?',
      options: ['Java', 'Kotlin', 'Dart', 'Swift'],
      correctIndex: 2,
    ),
    QuizQuestion(
      question:
          'Which widget is used for a layout that aligns its children vertically?',
      options: ['Row', 'Column', 'Stack', 'Wrap'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'How do you update the UI in a StatefulWidget?',
      options: ['updateUI()', 'setState()', 'build()', 'refresh()'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: 'Which of the following is NOT a valid state in Flutter?',
      options: ['Stateless', 'Stateful', 'Inherited', 'Reactive'],
      correctIndex: 3,
    ),
    QuizQuestion(
      question: 'What command is used to build an APK in Flutter?',
      options: [
        'flutter build apk',
        'flutter create apk',
        'flutter run apk',
        'flutter make apk',
      ],
      correctIndex: 0,
    ),
  ];

  int _currentIndex = 0;
  List<int?> _selectedAnswers = [];
  bool _isQuizFinished = false;

  Timer? _timer;
  int _remainingSeconds = 300; // 5 minutes

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<int?>.filled(_questions.length, null);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _finishQuiz();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _answerQuestion(int index) {
    setState(() {
      _selectedAnswers[_currentIndex] = index;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _finishQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _finishQuiz() {
    _timer?.cancel();
    setState(() {
      _isQuizFinished = true;
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctIndex) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder(
     stream: InternetConnectivityChecker().connectionStream,
      initialData: true, // Assume connected initially
      builder: (context, snapshot) {
        // Handle error state
        if (snapshot.hasError) {
          return const NoInternetPage();
        }

        // Handle disconnected state
        if (snapshot.data == false) {
          return const NoInternetPage();
        }

        // Handle loading state
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.veryLightGray,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark ? Colors.white : AppColors.darkGray,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              _isQuizFinished ? 'Quiz Results' : 'Quiz Assessment',
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.darkGray,
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: _isQuizFinished
                ? _buildResultSection(isDark)
                : _buildQuizSection(isDark),
          ),
        );
      }
    );
  }

  Widget _buildQuizSection(bool isDark) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Column(
      children: [
        // Top section with timer and progress
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1}/${_questions.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.mediumGray,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _remainingSeconds < 60
                          ? AppColors.errorLight
                          : AppColors.primaryBlueLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: _remainingSeconds < 60
                              ? AppColors.error
                              : AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(_remainingSeconds),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: _remainingSeconds < 60
                                ? AppColors.error
                                : AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightGray,
                color: AppColors.accentOrange,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Question Card
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.darkGray,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: question.options.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final isSelected =
                          _selectedAnswers[_currentIndex] == index;
                      return GestureDetector(
                        onTap: () => _answerQuestion(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryBlue.withValues(alpha:0.1)
                                : (isDark
                                      ? AppColors.darkBackground
                                      : AppColors.offWhite),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryBlue
                                  : (isDark
                                        ? AppColors.darkTextSecondary
                                              .withValues(alpha:0.1)
                                        : AppColors.lightGray),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : (isDark
                                            ? AppColors.darkBackground
                                            : Colors.white),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : AppColors.mediumGray,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : Center(
                                        child: Text(
                                          String.fromCharCode(
                                            65 + index,
                                          ), // A, B, C, D
                                          style: TextStyle(
                                            color: AppColors.mediumGray,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.darkGray,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Navigation Buttons
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          color: isDark ? AppColors.darkBackground : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _currentIndex > 0
                  ? OutlinedButton(
                      onPressed: _previousQuestion,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColors.primaryBlue),
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : const SizedBox(),
              ElevatedButton(
                onPressed: _selectedAnswers[_currentIndex] != null
                    ? _nextQuestion
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  disabledBackgroundColor: AppColors.primaryBlueLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentIndex == _questions.length - 1 ? 'Finish' : 'Next',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection(bool isDark) {
    final score = _calculateScore();
    final percentage = score / _questions.length;

    String message;
    Color scoreColor;
    if (percentage >= 0.8) {
      message = 'Excellent work!';
      scoreColor = AppColors.success;
    } else if (percentage >= 0.5) {
      message = 'Good job!';
      scoreColor = AppColors.warning;
    } else {
      message = 'Keep practicing!';
      scoreColor = AppColors.error;
    }

    return Column(
      children: [
        // Score Summary Header
        Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scoreColor.withValues(alpha:0.1),
                  border: Border.all(color: scoreColor, width: 4),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score/${_questions.length}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: scoreColor,
                        ),
                      ),
                      Text(
                        'Score',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Here is a review of your answers:',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ),

        // Detailed Answers List
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                final selectedAnswer = _selectedAnswers[index];
                final isCorrect = selectedAnswer == question.correctIndex;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBackground
                        : AppColors.veryLightGray,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCorrect
                          ? AppColors.successLight
                          : AppColors.errorLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? AppColors.success
                                  : AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCorrect ? Icons.check : Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Q${index + 1}: ${question.question}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.darkGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Show student answer
                      if (selectedAnswer != null) ...[
                        _buildResultOption(
                          text:
                              'Your Answer: ${question.options[selectedAnswer]}',
                          color: isCorrect
                              ? AppColors.success
                              : AppColors.error,
                          icon: isCorrect ? Icons.check_circle : Icons.cancel,
                          isDark: isDark,
                        ),
                      ] else ...[
                        _buildResultOption(
                          text: 'You skipped this question',
                          color: AppColors.warning,
                          icon: Icons.remove_circle,
                          isDark: isDark,
                        ),
                      ],
                      // Show correct answer if student got it wrong
                      if (!isCorrect) ...[
                        const SizedBox(height: 8),
                        _buildResultOption(
                          text:
                              'Correct Answer: ${question.options[question.correctIndex]}',
                          color: AppColors.success,
                          icon: Icons.check_circle,
                          isDark: isDark,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Try Again Button
        Container(
          padding: const EdgeInsets.all(20),
          color: isDark ? AppColors.darkBackground : Colors.white,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Back to Course',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultOption({
    required String text,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.darkGray,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
