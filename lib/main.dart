import 'package:flutter/material.dart';
import 'package:flutter_food/models/splashScreen.dart';
import 'package:flutter_food/theme/app_theme.dart';
import 'package:flutter_food/theme/theme_notifier.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadThemePreference();

  runApp(
    ChangeNotifierProvider.value(
      value: themeNotifier,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MaterialApp(
          title: 'Food',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeNotifier.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}