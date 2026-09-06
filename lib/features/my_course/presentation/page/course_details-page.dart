import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/features/pdf/pdf_panel.dart';
import 'package:online_course/features/test/presentation/widgets/quiz_introduction.dart';
import 'package:share_plus/share_plus.dart';

class CourseDetailsPage extends StatefulWidget {
  const CourseDetailsPage({super.key});

  static const String routeName = '/course-details';

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _descExpanded = false;
  int? _playingVideo; // index of the currently "playing" demo video

  // ─── Static Demo Data ────────────────────────────────────────────────────
  static const String _courseName = 'Flutter App Development Masterclass';
  static const String _category = 'Development';
  static const String _originalFee = '₹8,999';
  static const String _discountedFee = '₹4,999';
  static const String _discount = '44% OFF';
  static const String _duration = '6 Months';
  static const String _totalHours = '120+ Hours';
  static const String _totalLessons = '48 Lessons';
  static const String _level = 'Beginner to Pro';
  static const double _rating = 4.8;
  static const int _reviewCount = 1250;
  static const double _progressPct = 35;
  static const int _completedLessons = 17;
  static const int _totalLessonsCount = 48;

  static const String _description =
      'This comprehensive Flutter masterclass takes you from absolute beginner to '
      'confident app developer. You will build 10+ real-world projects, learn '
      'industry-standard patterns (BLoC, MVVM, Clean Architecture), integrate REST APIs, '
      'implement beautiful animations, and publish your apps to both Google Play and the '
      'App Store.\n\n'
      'Each module is carefully structured to build on the previous, ensuring you '
      'develop both depth and breadth of knowledge. By the end, you will have a '
      'professional portfolio and the skills employers are actively hiring for.';

  static const List<Map<String, String>> _demoVideos = [
    {
      'title': 'Introduction to Flutter & Dart',
      'duration': '12:30',
      'thumbnail': 'Lesson 1 — Free Preview',
      'topic': 'Getting Started',
    },
    {
      'title': 'Building Your First Flutter App',
      'duration': '20:45',
      'thumbnail': 'Lesson 2 — Free Preview',
      'topic': 'Core Concepts',
    },
    {
      'title': 'Widgets, State & UI Layouts',
      'duration': '25:10',
      'thumbnail': 'Lesson 3 — Free Preview',
      'topic': 'UI Fundamentals',
    },
    {
      'title': 'Navigation & GoRouter Setup',
      'duration': '18:00',
      'thumbnail': 'Lesson 4 — Free Preview',
      'topic': 'Navigation',
    },
  ];

  static const List<Map<String, String>> _highlights = [
    {'icon': '🚀', 'text': 'Build 10+ production-ready apps'},
    {'icon': '📦', 'text': 'Master BLoC state management'},
    {'icon': '🔌', 'text': 'REST API & Firebase integration'},
    {'icon': '🎨', 'text': 'Custom animations & UI design'},
    {'icon': '✅', 'text': 'Unit & widget testing'},
    {'icon': '📱', 'text': 'Publish to Play Store & App Store'},
  ];

  // ─── Colors helper ─────────────────────────────────────────────────────────
  Color _progressColor(double pct) {
    if (pct >= 100) return AppColors.success;
    if (pct >= 60) return AppColors.accentOrange;
    return AppColors.accentOrangeLight;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : const Color(0xFFF4F6FB);

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
          backgroundColor: bg,
          body: Stack(
            children: [
              // ── Scrollable content ─────────────────────────────────────────
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHero(isDark),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildPriceEnrollCard(isDark),
                        _buildCourseInfoCard(isDark),
                        _buildProgressSection(isDark),
                        _buildTabSection(isDark),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),

              // ── Floating back / actions ─────────────────────────────────────
              _buildFloatingBar(isDark),
            ],
          ),

          // ── Sticky bottom CTA ───────────────────────────────────────────────
          // bottomNavigationBar: _buildBottomBar(isDark),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  HERO
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHero(bool isDark) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 200,
      pinned: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient background (replaces image for static demo)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F2460),
                    AppColors.primaryBlue,
                    AppColors.tertiaryPurple.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Decorative circles
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Content
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category badge
                  _badge(_category, AppColors.accentOrange),
                  const SizedBox(height: 12),

                  // Course name
                  Text(
                    _courseName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rating row
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < _rating.floor()
                              ? Icons.star_rounded
                              : (i < _rating
                                    ? Icons.star_half_rounded
                                    : Icons.star_outline_rounded),
                          color: AppColors.accentOrange,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$_rating  ($_reviewCount reviews)',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  PRICE / ENROLL CARD
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildPriceEnrollCard(bool isDark) {
    final surface = isDark ? AppColors.darkSurface : Colors.white;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [_shadow()],
      ),
      child: Row(
        children: [
          // Price block
          Expanded(
            // flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _discountedFee,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _originalFee,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mediumGray,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$_discount · Limited time offer',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Bookmark button
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 45,
                // width: MediaQuery.sizeOf(context).width * 0.40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentOrange, AppColors.darkOrange],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentOrange.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_open_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Enroll Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  COURSE INFO CARD  (quick stats + mentor)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCourseInfoCard(bool isDark) {
    final surface = isDark ? AppColors.darkSurface : Colors.white;

    final stats = [
      {
        'icon': Icons.access_time_rounded,
        'label': 'Duration',
        'value': _duration,
      },
      {
        'icon': Icons.play_lesson_rounded,
        'label': 'Lessons',
        'value': _totalLessons,
      },
      {'icon': Icons.timer_outlined, 'label': 'Video', 'value': _totalHours},
      {
        'icon': Icons.signal_cellular_alt_rounded,
        'label': 'Level',
        'value': _level,
      },
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [_shadow()],
      ),
      child: Column(
        children: [
          // Quick stats row
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: stats.asMap().entries.map((e) {
                final isLast = e.key == stats.length - 1;
                final s = e.value;
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : Border(
                              right: BorderSide(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.07)
                                    : Colors.grey.withValues(alpha: 0.15),
                              ),
                            ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          s['icon'] as IconData,
                          color: AppColors.primaryBlue,
                          size: 18,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          s['value'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.darkGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s['label'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Divider(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.grey.withValues(alpha: 0.12),
          ),

          // Mentor section
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  PROGRESS CARD
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildProgressSection(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_progressPct.toStringAsFixed(0)}% Complete',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progressPct / 100,
              minHeight: 9,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                _progressColor(_progressPct),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_completedLessons of $_totalLessonsCount lessons completed',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.80),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TAB SECTION
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildTabSection(bool isDark) {
    final surface = isDark ? AppColors.darkSurface : Colors.white;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [_shadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab bar
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.accentOrange,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: AppColors.accentOrange,
            unselectedLabelColor: isDark
                ? AppColors.darkTextSecondary
                : AppColors.mediumGray,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'About'),
              Tab(text: 'Videos'),
              Tab(text: 'Learning Material'),
            ],
          ),

          // Tab content (intrinsic height, no nested scroll needed)
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              switch (_tabController.index) {
                case 0:
                  return _buildAboutTab(isDark);
                case 1:
                  return _buildDemoVideosTab(isDark);
                case 2:
                  return _buildMentorTab(isDark);
                default:
                  return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  // ─── About Tab ─────────────────────────────────────────────────────────────
  Widget _buildAboutTab(bool isDark) {
    final textColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.mediumGray;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          _sectionHeading('Course Description', isDark),
          const SizedBox(height: 10),
          AnimatedCrossFade(
            firstChild: Text(
              _description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.5, color: textColor, height: 1.7),
            ),
            secondChild: Text(
              _description,
              style: TextStyle(fontSize: 13.5, color: textColor, height: 1.7),
            ),
            crossFadeState: _descExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => setState(() => _descExpanded = !_descExpanded),
            child: Text(
              _descExpanded ? 'Show less ▲' : 'Read more ▼',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
          ),

          const SizedBox(height: 20),
          _sectionHeading('What You\'ll Learn', isDark),
          const SizedBox(height: 12),
          ..._highlights.map(
            (h) => _learnPoint(h['icon']!, h['text']!, isDark),
          ),

          const SizedBox(height: 20),
          _sectionHeading('Course Details', isDark),
          const SizedBox(height: 12),
          _detailRow(
            Icons.calendar_month_rounded,
            'Duration',
            _duration,
            isDark,
          ),
          _detailRow(
            Icons.video_library_rounded,
            'Total Videos',
            _totalLessons,
            isDark,
          ),
          _detailRow(Icons.timer_rounded, 'Total Hours', _totalHours, isDark),
          _detailRow(Icons.bar_chart_rounded, 'Difficulty', _level, isDark),
          _detailRow(
            Icons.language_rounded,
            'Language',
            'English & Hindi',
            isDark,
          ),
          _detailRow(
            Icons.currency_rupee_rounded,
            'Course Fee',
            '$_discountedFee (was $_originalFee)',
            isDark,
          ),
          _detailRow(
            Icons.verified_rounded,
            'Certificate',
            'Yes, upon completion',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _learnPoint(String emoji, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.darkGray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 17),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.mediumGray,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.darkGray,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Demo Videos Tab ────────────────────────────────────────────────────────
  Widget _buildDemoVideosTab(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header strip
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accentOrange.withValues(alpha: 0.08),
                  AppColors.darkOrange.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accentOrange.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.play_circle_fill_rounded,
                  color: AppColors.accentOrange,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Free Demo Videos',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accentOrange,
                        ),
                      ),
                      Text(
                        'Watch 4 lessons for free before enrolling',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '4 Videos',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentOrange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Video cards
          ..._demoVideos.asMap().entries.map(
            (e) => _buildVideoCard(e.key, e.value, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(int index, Map<String, String> video, bool isDark) {
    final isPlaying = _playingVideo == index;
    final cardBg = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : AppColors.veryLightGray;

    return GestureDetector(
      onTap: () {
        setState(() {
          _playingVideo = isPlaying ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isPlaying
              ? AppColors.primaryBlue.withValues(alpha: 0.07)
              : cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPlaying
                ? AppColors.primaryBlue.withValues(alpha: 0.4)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isPlaying
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            // Main row
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Thumbnail / play area
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isPlaying
                            ? [AppColors.primaryBlue, AppColors.tertiaryPurple]
                            : [
                                AppColors.primaryBlue.withValues(alpha: 0.75),
                                AppColors.primaryBlueDark.withValues(
                                  alpha: 0.75,
                                ),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Number watermark
                        Positioned(
                          top: 6,
                          left: 8,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Text info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            video['topic']!,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentOrange,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          video['title']!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.darkGray,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.mediumGray,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              video['duration']!,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.mediumGray,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'FREE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.success,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  Icon(
                    isPlaying
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: isPlaying
                        ? AppColors.primaryBlue
                        : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.mediumGray),
                  ),
                ],
              ),
            ),

            // "Player" placeholder (shown when tapped)
            if (isPlaying)
              Container(
                height: 170,
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F2460), AppColors.primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.pause_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      video['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    // Fake progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          value: 0.28,
                          minHeight: 4,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.accentOrange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '3:28 / ${video['duration']}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Mentor Tab ─────────────────────────────────────────────────────────────
  Widget _buildMentorTab(bool isDark) {
    final textColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.mediumGray;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      child: SizedBox(
        height: 500,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: AppColors.darkTextSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  onTap: () {
                    GoRouter.of(context).pushNamed(PDFPanel.routeName);
                  },
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text('Lesson ${index + 1}'),
                  trailing: Icon(Icons.download),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  FLOATING TOP BAR
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildFloatingBar(bool isDark) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            _iconBtn(
              Icons.arrow_back_ios_new_rounded,
              () => Navigator.of(context).pop(),
            ),
            const Spacer(),
            Row(
              spacing: 10,
              children: [
                _iconBtn(Icons.quiz_outlined, () {
                  GoRouter.of(context).pushNamed(QuizIntroduction.routeName);
                }),
                _iconBtn(Icons.share_rounded, () {
                  SharePlus.instance.share(
                    ShareParams(
                      text: 'check out this course https://example.com',
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.40),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SHARED HELPERS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _sectionHeading(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: isDark ? AppColors.darkTextPrimary : AppColors.darkGray,
        letterSpacing: -0.2,
      ),
    );
  }

  BoxShadow _shadow() => BoxShadow(
    color: Colors.black.withValues(alpha: 0.07),
    blurRadius: 14,
    offset: const Offset(0, 4),
  );
}
