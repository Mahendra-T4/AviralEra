import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/utils/custom_text.dart';
import 'package:online_course/features/global/presentation/section_heading.dart';
import 'package:online_course/features/my_course/domain/entities/category_entitie.dart';
import 'package:online_course/features/my_course/presentation/bloc/course_bloc.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CourseBloc>()
            ..add(GetCourseListEvent(entity: CourseFilterEntity())),
      child: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case CourseLoadingState:
              return Center(child: CircularProgressIndicator());
            case CourseListLoadedSuccessState:
              final data = (state as CourseListLoadedSuccessState).model;
              return data.status != 1
                  ? Center(child: Text(data.message.toString()))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SectionHeader(
                            title: 'Explore Categories',
                            actionLabel: 'See All',
                            onAction: () {},
                          ),
                        ),
                        const SizedBox(height: 14),
                        Builder(
                          builder: (context) {
                            return SizedBox(
                              height: 136,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.courseList?.length,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 4,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      right: 12,
                                      bottom: 6,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Color(
                                            int.parse(
                                              "0xFF${data.courseList?[index].courseColorCode}",
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(
                                                int.parse(
                                                  "0xFF${data.courseList?[index].courseColorCode}",
                                                ),
                                              ).withValues(alpha: 0.35),
                                              blurRadius: 12,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.antiAlias,
                                          children: [
                                            // Decorative circle top-right
                                            Positioned(
                                              top: -14,
                                              right: -14,
                                              child: Container(
                                                width: 52,
                                                height: 52,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            // Content
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      height: 52,
                                                      width: 52,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.2,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                            12,
                                                          ),
                                                      child: Image.network(
                                                        "https://images.unsplash.com/photo-1680652439294-88a2c46a4402?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                                        fit: BoxFit.contain,
                                                        color: Color(
                                                          int.parse(
                                                            "0xff${data.courseList![index].courseColorCode}",
                                                          ),
                                                        ),
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) {
                                                              return const Icon(
                                                                Icons
                                                                    .school_rounded,
                                                                color: Colors
                                                                    .white,
                                                                size: 28,
                                                              );
                                                            },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                        ),
                                                    child: CustomText(
                                                      text: data
                                                          .courseList![index]
                                                          .courseName
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                      isSemibold: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
            case CourseListFailedErrorState:
            default:
              return Center(child: Text('State not found'));
          }
        },
      ),
    );
  }
}
