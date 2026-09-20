import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/service/connectivity/connectivity_checker.dart';
import 'package:online_course/core/service/connectivity/no_internat_page.dart';
import 'package:online_course/features/global/presentation/section_heading.dart';
import 'package:online_course/features/my_course/domain/entities/category_entitie.dart';
import 'package:online_course/features/my_course/presentation/bloc/course_bloc.dart';
import 'package:online_course/features/my_course/presentation/page/course_details-page.dart';

class CourseSearchPage extends StatefulWidget {
  const CourseSearchPage({super.key});

  static const String routeName = '/course-search';

  @override
  State<CourseSearchPage> createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> {
  late CourseBloc _courseBloc;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  int _selectedCategoryIndex = 0;

  CourseFilterEntity courseFilterEntity = CourseFilterEntity();

  @override
  void initState() {
    super.initState();
    _courseBloc = context.read<CourseBloc>();
    _courseBloc.add(GetCourseListEvent(entity: courseFilterEntity));
    // Auto focus the search bar when the page opens
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : const Color(0xFFF4F6FB);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

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
          body: Column(
            children: [
              _buildHeader(isDark),
              _buildDefaultState(isDark),
              Expanded(child: courseTileWidget(isDark)),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  HEADER & SEARCH BAR
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ), // Status bar padding
          // Top Row (Back button & Title)
          Text(
            'Search Courses',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.darkTextPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 15),

          // Search Bar
          Container(
            height: 54,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColors.veryLightGray,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _searchFocusNode.hasFocus
                    ? AppColors.primaryBlue
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.search_rounded,
                  color: _searchFocusNode.hasFocus
                      ? AppColors.primaryBlue
                      : AppColors.mediumGray,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (val) {
                      _courseBloc.add(
                        GetCourseListEvent(
                          entity: CourseFilterEntity(
                            keyword: _searchController.text,
                          ),
                        ),
                      );
                    },
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.darkGray,
                    ),
                    decoration: InputDecoration(
                      hintText: 'What do you want to learn?',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mediumGray,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                      _searchFocusNode.requestFocus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.mediumGray,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  DEFAULT STATE (Before Searching)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildDefaultState(bool isDark) {
    return BlocProvider(
      create: (context) => sl<CourseBloc>()..add(GetCourseCategoryEvent()),
      child: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case CourseLoadingState1:
              return const Center(child: CircularProgressIndicator());
            case CourseCategoryLoadedSuccessState:
              final data = (state as CourseCategoryLoadedSuccessState).model;

              if (data.status != 1) {
                return Center(child: Text(data.message.toString()));
              }

              final _categories = data.categoryList;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Explore Categories',
                      actionLabel: '',
                      onAction: () {},
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      child: Row(
                        children: _categories!.asMap().entries.map((entry) {
                          final idx = entry.key;

                          final isSelected = _selectedCategoryIndex == idx;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = idx;
                              });

                              _courseBloc.add(
                                GetCourseListEvent(
                                  entity: CourseFilterEntity(
                                    categoryKey:
                                        data.categoryList![idx].categoryKey,
                                  ),
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryBlue
                                    : (isDark
                                          ? AppColors.darkSurface
                                          : Colors.white),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primaryBlue
                                              .withValues(alpha: 0.35),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.04,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : (isDark
                                            ? Colors.white.withValues(
                                                alpha: 0.05,
                                              )
                                            : Colors.grey.withValues(
                                                alpha: 0.15,
                                              )),
                                ),
                              ),
                              child: Text(
                                _categories[idx].categoryName ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.darkGray),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // const SizedBox(height: 32),
                    // _sectionTitle('Recent Searches', isDark),
                    // const SizedBox(height: 16),

                    // ..._recentSearches.map(
                    //   (search) => _recentSearchTile(search, isDark),
                    // ),
                  ],
                ),
              );
            case CourseCategoryFailedErrorState:
              return Center(child: Text('Opps! Something went wrong.'));
            default:
              return const Center(child: Text('Opps! Unknown state found.'));
          }
        },
      ),
    );
  }

  Widget courseTileWidget(bool isDark) {
    return BlocBuilder(
      bloc: _courseBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case CourseLoadingState:
            return Center(child: CircularProgressIndicator());
          case CourseListLoadedSuccessState:
            final data = (state as CourseListLoadedSuccessState).model;
            if (data.status != 1) {
              return Center(child: Text(data.message.toString()));
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SectionHeader(
                      title: 'Courses',
                      actionLabel: '',
                      onAction: () {},
                    ),
                  ),
                  // const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.courseList?.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () =>
                              context.pushNamed(CourseDetailsPage.routeName),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Thumbnail
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        data.courseList![index].courseIcon
                                            .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withValues(
                                                alpha: 0.4,
                                              ),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: AppColors.accentOrange,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              '4.8',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),

                                Text(
                                  data.courseList![index].courseName.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.darkGray,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          case CourseListFailedErrorState:
            return const Center(child: Text("Opps! Something went wrong."));
          default:
            return const Center(child: Text("Opps! Unknown state found"));
        }
      },
    );
  }

 
}
