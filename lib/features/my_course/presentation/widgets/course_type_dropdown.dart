import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_course/core/constants/app_colors.dart';
import 'package:online_course/core/di/sl.dart';
import 'package:online_course/core/utils/custom_toast.dart';
import 'package:online_course/features/my_course/presentation/bloc/course_bloc.dart';

class CourseTypeDropdownWidget extends StatefulWidget {
  const CourseTypeDropdownWidget({
    super.key,
    this.onChanged,
    this.courseName,
  });
  final void Function(String?)? onChanged;
  final String? courseName;

  @override
  State<CourseTypeDropdownWidget> createState() =>
      _CourseTypeDropdownWidgetState();
}

class _CourseTypeDropdownWidgetState extends State<CourseTypeDropdownWidget> {
  late CourseBloc _courseBloc;

  @override
  void initState() {
    super.initState();
    _courseBloc = sl<CourseBloc>();
    _courseBloc.add(GetCourseTypeEvent());
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
        if (state is CourseTypeFailedErrorState) {
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
          case CourseLoadingState1:
            return const Center(child: CircularProgressIndicator());
          case CourseTypeLoadedSuccessState:
            final courseTypeModel =
                (state as CourseTypeLoadedSuccessState).model;
            final items = (courseTypeModel.courseList ?? [])
                .where((item) => item.courseKey != null)
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item.courseKey,
                    child: Text(item.courseType?.toString() ?? ''),
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
                      labelText: 'Course Type',
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
