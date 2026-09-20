// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:online_course/core/constants/app_colors.dart';
// import 'package:online_course/core/di/sl.dart';
// import 'package:online_course/features/my_course/domain/entities/category_entitie.dart';
// import 'package:online_course/features/my_course/presentation/bloc/course_bloc.dart';

// class CategoryWidget extends StatelessWidget {
//   CategoryWidget({
//     super.key,
//     this.isDark = false,
//     this.categoryKey,
//     this.categorySlug,
//   });
//   String? categoryKey;
//   String? categorySlug;
//   final bool isDark;

//   int _selectedCategoryIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => sl<CourseBloc>()..add(GetCourseCategoryEvent()),
//       child: BlocBuilder<CourseBloc, CourseState>(
//         builder: (context, state) {
//           switch (state.runtimeType) {
//             case CourseLoadingState1:
//               return const Center(child: CircularProgressIndicator());
//             case CourseCategoryLoadedSuccessState:
//               final data = (state as CourseCategoryLoadedSuccessState).model;

//               if (data.status != 1) {
//                 return Center(child: Text(data.message.toString()));
//               }

//               final _categories = data.categoryList;

//               return SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _sectionTitle('Categories', isDark),
//                     const SizedBox(height: 16),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       physics: const BouncingScrollPhysics(),
//                       clipBehavior: Clip.none,
//                       child: Row(
//                         children: _categories!.asMap().entries.map((entry) {
//                           final idx = entry.key;
//                           final cat = entry.value;
//                           final isSelected = _selectedCategoryIndex == idx;

//                           return GestureDetector(
//                             onTap: () {
//                               _selectedCategoryIndex = idx;
//                               categoryKey = _categories[idx].categoryKey;
//                               categorySlug = _categories[idx].categorySlug;
//                               sl<CourseBloc>()..add(
//                                 GetCourseListEvent(
//                                   entity: CourseFilterEntity(
//                                     categoryKey: categoryKey,
//                                     popularCategory: categorySlug,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 200),
//                               margin: const EdgeInsets.only(right: 12),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 12,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: isSelected
//                                     ? AppColors.primaryBlue
//                                     : (isDark
//                                           ? AppColors.darkSurface
//                                           : Colors.white),
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: isSelected
//                                     ? [
//                                         BoxShadow(
//                                           color: AppColors.primaryBlue
//                                               .withValues(alpha: 0.35),
//                                           blurRadius: 12,
//                                           offset: const Offset(0, 4),
//                                         ),
//                                       ]
//                                     : [
//                                         BoxShadow(
//                                           color: Colors.black.withValues(
//                                             alpha: 0.04,
//                                           ),
//                                           blurRadius: 8,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                 border: Border.all(
//                                   color: isSelected
//                                       ? Colors.transparent
//                                       : (isDark
//                                             ? Colors.white.withValues(
//                                                 alpha: 0.05,
//                                               )
//                                             : Colors.grey.withValues(
//                                                 alpha: 0.15,
//                                               )),
//                                 ),
//                               ),
//                               child: Text(
//                                 _categories[idx].categoryName ?? '',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w700,
//                                   color: isSelected
//                                       ? Colors.white
//                                       : (isDark
//                                             ? AppColors.darkTextSecondary
//                                             : AppColors.darkGray),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),

//                     // const SizedBox(height: 32),
//                     // _sectionTitle('Recent Searches', isDark),
//                     // const SizedBox(height: 16),

//                     // ..._recentSearches.map(
//                     //   (search) => _recentSearchTile(search, isDark),
//                     // ),
//                   ],
//                 ),
//               );
//             case CourseCategoryFailedErrorState:
//               return Center(child: Text('Opps! Something went wrong.'));
//             default:
//               return const Center(child: Text('Opps! Unknown state found.'));
//           }
//         },
//       ),
//     );
//   }

//   Widget _sectionTitle(String title, bool isDark) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.w800,
//         color: isDark ? AppColors.darkTextPrimary : AppColors.darkGray,
//         letterSpacing: -0.3,
//       ),
//     );
//   }
// }
