import 'package:get_it/get_it.dart';
import 'package:online_course/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:online_course/features/auth/domain/repositories/auth_repositories.dart';
import 'package:online_course/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_course/features/my_course/data/repositories/course_repo_impl.dart';
import 'package:online_course/features/my_course/domain/repositories/course_repo.dart';
import 'package:online_course/features/my_course/presentation/bloc/course_bloc.dart';
import 'package:online_course/features/notification/data/repositories/notification_repo_impl.dart';
import 'package:online_course/features/notification/domain/repositories/notification_repo.dart';
import 'package:online_course/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:online_course/features/profile/data/repositories/profile_repo_impl.dart';
import 'package:online_course/features/profile/domain/repositories/profile_repo.dart';
import 'package:online_course/features/profile/presentation/bloc/profile_bloc.dart';

final GetIt sl = GetIt.instance;

class SLServices {
  static Future<void> init() async {
    initRepositories();
    initBloc();
  }

  static void initRepositories() async {
    sl.registerLazySingleton<AuthRepositories>(() => AuthRepositoriesImpl());
    sl.registerLazySingleton<CourseRepository>(() => CourseRepoImpl());
    sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
    sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(),
    );
  }

  static void initBloc() {
    sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepositories>()));
    sl.registerFactory<CourseBloc>(() => CourseBloc(sl<CourseRepository>()));
    sl.registerFactory<ProfileBloc>(
      () => ProfileBloc(repository: sl<ProfileRepository>()),
    );

    sl.registerFactory<NotificationBloc>(
      () => NotificationBloc(sl<NotificationRepository>()),
    );
  }
}
