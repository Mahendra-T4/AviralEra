import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/utils/custom_toast.dart';
import 'package:online_course/features/my_course/presentation/bloc/course_bloc.dart';

class CourseListDropdownWidget extends StatefulWidget {
  const CourseListDropdownWidget({
    super.key,
    this.onChanged,
    this.courseName,
  });
  final void Function(String?)? onChanged;
  final String? courseName;

  @override
  State<CourseListDropdownWidget> createState() =>
      _CourseListDropdownWidgetState();
}

class _CourseListDropdownWidgetState extends State<CourseListDropdownWidget> {
  late CourseBloc _courseBloc;

  @override
  void initState() {
    super.initState();
    _courseBloc = sl<CourseBloc>();
    _courseBloc.add(GetCourseListEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        (isDark ? Colors.white : AppColors.darkGray);

    return BlocConsumer(
      bloc: _courseBloc,
      listener: (context, state) {
        if (state is CourseListFailedErrorState) {
          ToastUtils.showToast(
            context,
            ToastType.error,
            textColor,
            message: state.error,
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case CourseLoadingState:
            return const Center(child: CircularProgressIndicator());
          case CourseListLoadedSuccessState:
            final courseTypeModel =
                (state as CourseListLoadedSuccessState).model;
            final items = (courseTypeModel.courseList ?? [])
                .where((item) => item.courseKey != null)
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item.courseKey,
                    child: Text(item.courseName?.toString() ?? ''),
                  ),
                )
                .toList();
            final isValidValue = widget.courseName != null &&
                items.any((item) => item.value == widget.courseName);

            return courseTypeModel.status != 1
                ? Center(child: Text(courseTypeModel.message.toString()))
                : DropdownButtonFormField<String>(
                    initialValue: isValidValue ? widget.courseName : null,
                    items: items,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      labelText: 'Course Name',
                      prefixIcon: Icon(
                        Icons.school_outlined,
                        color: isDark
                            ? Colors.blue[200]
                            : AppColors.primaryBlue,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF111827)
                          : AppColors.primaryBlueLighter,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.grey[700]!
                              : AppColors.lightGray,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.grey[700]!
                              : AppColors.lightGray,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.blue[300]!
                              : AppColors.primaryBlue,
                          width: 2,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: isDark ? Colors.white70 : AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select course';
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  );
          default:
            return const Center(child: SizedBox.shrink());
        }
      },
    );
  }
}
