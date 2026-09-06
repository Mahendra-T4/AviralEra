import 'package:get_it/get_it.dart';
import 'package:online_course/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:online_course/features/auth/domain/repositories/auth_repositories.dart';
import 'package:online_course/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_course/features/my_course/data/repositories/course_repo_impl.dart';
import 'package:online_course/features/my_course/domain/repositories/course_repo.dart';
import 'package:online_course/features/my_course/presentation/bloc/course_bloc.dart';

final GetIt sl = GetIt.instance;

class SLServices {
  static Future<void> init() async {
    initRepositories();
    initBloc();
  }

  static void initRepositories() async {
    sl.registerLazySingleton<AuthRepositories>(() => AuthRepositoriesImpl());
    sl.registerLazySingleton<CourseRepository>(() => CourseRepoImpl());
  }

  static void initBloc() {
    sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepositories>()));
    sl.registerFactory<CourseBloc>(() => CourseBloc(sl<CourseRepository>()));
  }
}
