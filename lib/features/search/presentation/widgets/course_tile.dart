// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:online_course/core/constants/app_colors.dart';
// import 'package:online_course/core/di/sl.dart';
// import 'package:online_course/features/my_course/data/model/course_list_modeld.dart';
// import 'package:online_course/features/my_course/domain/entities/category_entitie.dart';
// import 'package:online_course/features/my_course/presentation/bloc/course_bloc.dart';
// import 'package:online_course/features/my_course/presentation/page/course_details-page.dart';

// class CourseTileWidget extends StatelessWidget {
//   const CourseTileWidget({super.key, this.isDark = false});
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           sl<CourseBloc>()
//             ..add(GetCourseListEvent(entity: CourseFilterEntity())),
//       child: 
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

//   Widget _buildCourseCard(
//     CourseList course,
//     bool isDark,
//     BuildContext context,
//   ) {
//     return GestureDetector(
//       onTap: () => context.pushNamed(CourseDetailsPage.routeName),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isDark ? AppColors.darkSurface : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Thumbnail
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(14),
//                 image: DecorationImage(
//                   image: NetworkImage(course.courseIcon.toString()),
//                   fit: BoxFit.cover,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.1),
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(14),
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withValues(alpha: 0.4),
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 8,
//                     left: 8,
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.star_rounded,
//                           color: AppColors.accentOrange,
//                           size: 14,
//                         ),
//                         const SizedBox(width: 4),
//                         const Text(
//                           '4.8',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16),

//             // Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryBlue.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       'Development',
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.primaryBlue,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     course.courseName.toString(),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w800,
//                       color: isDark
//                           ? AppColors.darkTextPrimary
//                           : AppColors.darkGray,
//                       height: 1.2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
