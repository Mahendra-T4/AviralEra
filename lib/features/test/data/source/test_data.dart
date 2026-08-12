class TestModel {
  final String id;
  final String title;
  final String courseTitle;
  final String description;
  final int totalQuestions;
  final int duration; // in minutes
  final double passingScore; // percentage
  final String difficulty; // Easy, Medium, Hard
  final String status; // Not Started, In Progress, Completed
  final double? score; // if completed
  final int attempts;
  final int maxAttempts;
  final DateTime scheduledDate;
  final DateTime? deadline;
  final String testType; // Quiz, Midterm, Final, Assignment
  final List<String> topics;

  TestModel({
    required this.id,
    required this.title,
    required this.courseTitle,
    required this.description,
    required this.totalQuestions,
    required this.duration,
    required this.passingScore,
    required this.difficulty,
    required this.status,
    this.score,
    required this.attempts,
    required this.maxAttempts,
    required this.scheduledDate,
    this.deadline,
    required this.testType,
    required this.topics,
  });

  bool get isPassed => score != null && score! >= passingScore;
  bool get isAvailable => DateTime.now().isAfter(scheduledDate);
  bool get isExpired => deadline != null && DateTime.now().isAfter(deadline!);
}

final List<TestModel> allTests = [
  TestModel(
    id: '1',
    title: 'Flutter Basics Quiz',
    courseTitle: 'Flutter App Development',
    description:
        'Test your knowledge on Flutter fundamentals and widget basics',
    totalQuestions: 15,
    duration: 30,
    passingScore: 70,
    difficulty: 'Easy',
    status: 'Completed',
    score: 85,
    attempts: 1,
    maxAttempts: 3,
    scheduledDate: DateTime.now().subtract(const Duration(days: 45)),
    deadline: DateTime.now().add(const Duration(days: 10)),
    testType: 'Quiz',
    topics: ['Widgets', 'State Management', 'Layouts'],
  ),
  TestModel(
    id: '2',
    title: 'State Management Midterm',
    courseTitle: 'Flutter App Development',
    description: 'Comprehensive test covering BLoC, Provider, and Riverpod',
    totalQuestions: 25,
    duration: 60,
    passingScore: 75,
    difficulty: 'Hard',
    status: 'In Progress',
    attempts: 1,
    maxAttempts: 2,
    scheduledDate: DateTime.now().subtract(const Duration(days: 5)),
    deadline: DateTime.now().add(const Duration(days: 5)),
    testType: 'Midterm',
    topics: ['BLoC Pattern', 'Provider', 'State Management'],
  ),
  TestModel(
    id: '3',
    title: 'Web Design Fundamentals',
    courseTitle: 'Web Design Masterclass',
    description:
        'Test your understanding of design principles and UI/UX basics',
    totalQuestions: 20,
    duration: 45,
    passingScore: 70,
    difficulty: 'Medium',
    status: 'Not Started',
    attempts: 0,
    maxAttempts: 3,
    scheduledDate: DateTime.now().add(const Duration(days: 2)),
    deadline: DateTime.now().add(const Duration(days: 15)),
    testType: 'Quiz',
    topics: ['Color Theory', 'Typography', 'Layout Design'],
  ),
  TestModel(
    id: '4',
    title: 'JavaScript Advanced Concepts',
    courseTitle: 'Advanced JavaScript',
    description: 'Deep dive into closures, prototypes, async/await, and more',
    totalQuestions: 30,
    duration: 75,
    passingScore: 75,
    difficulty: 'Hard',
    status: 'Completed',
    score: 92,
    attempts: 2,
    maxAttempts: 3,
    scheduledDate: DateTime.now().subtract(const Duration(days: 20)),
    deadline: DateTime.now().add(const Duration(days: 30)),
    testType: 'Midterm',
    topics: ['Closures', 'Prototypes', 'Async Programming', 'Error Handling'],
  ),
  TestModel(
    id: '5',
    title: 'UI/UX Design Final Exam',
    courseTitle: 'UI/UX Design Principles',
    description:
        'Comprehensive final examination covering all course materials',
    totalQuestions: 40,
    duration: 120,
    passingScore: 80,
    difficulty: 'Hard',
    status: 'Completed',
    score: 88,
    attempts: 1,
    maxAttempts: 1,
    scheduledDate: DateTime.now().subtract(const Duration(days: 10)),
    deadline: DateTime.now().add(const Duration(days: 50)),
    testType: 'Final',
    topics: [
      'User Research',
      'Wireframing',
      'Prototyping',
      'Usability Testing',
    ],
  ),
  TestModel(
    id: '6',
    title: 'React Native Components',
    courseTitle: 'React Native Complete Guide',
    description: 'Quick quiz on React Native components and their usage',
    totalQuestions: 12,
    duration: 20,
    passingScore: 70,
    difficulty: 'Easy',
    status: 'Not Started',
    attempts: 0,
    maxAttempts: 3,
    scheduledDate: DateTime.now().subtract(const Duration(days: 1)),
    deadline: DateTime.now().add(const Duration(days: 7)),
    testType: 'Quiz',
    topics: ['Components', 'Props', 'State', 'Navigation'],
  ),
  TestModel(
    id: '7',
    title: 'Web Design Project Assignment',
    courseTitle: 'Web Design Masterclass',
    description: 'Design a complete website based on given requirements',
    totalQuestions: 1,
    duration: 480,
    passingScore: 70,
    difficulty: 'Hard',
    status: 'In Progress',
    attempts: 1,
    maxAttempts: 1,
    scheduledDate: DateTime.now().subtract(const Duration(days: 3)),
    deadline: DateTime.now().add(const Duration(days: 20)),
    testType: 'Assignment',
    topics: ['Full Website Design', 'Responsive Design', 'User Experience'],
  ),
  TestModel(
    id: '8',
    title: 'JavaScript ES6+ Features',
    courseTitle: 'Advanced JavaScript',
    description: 'Quick quiz on modern JavaScript features and syntax',
    totalQuestions: 15,
    duration: 25,
    passingScore: 70,
    difficulty: 'Medium',
    status: 'Not Started',
    attempts: 0,
    maxAttempts: 3,
    scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
    deadline: DateTime.now().add(const Duration(days: 5)),
    testType: 'Quiz',
    topics: ['Arrow Functions', 'Destructuring', 'Spread Operator', 'Promises'],
  ),
];
