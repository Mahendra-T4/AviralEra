import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_course/core/theme/app_theme.dart';
import 'package:online_course/core/bloc/theme_bloc.dart';
import 'package:online_course/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final themeBloc = ThemeBloc();
        themeBloc.add(LoadThemeEvent());
        return themeBloc;
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Aviral Era',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            routerConfig: Routers.router,
          );
        },
      ),
    );
  }
}
