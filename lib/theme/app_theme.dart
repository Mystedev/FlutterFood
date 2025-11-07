import 'package:flutter/material.dart';

class AppTheme {
  static const _seedColor = Color(0xFF14532D);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 46, 93, 65),
        brightness: Brightness.light,
        surface: const Color.fromARGB(255, 255, 255, 255),
        surfaceContainer: const Color.fromARGB(255, 15, 34, 17),
        onPrimaryContainer: const Color.fromARGB(255, 222, 246, 222),
        onPrimary: Colors.white,
        primaryFixed: Colors.lightBlue,
        onTertiary: const Color.fromARGB(255, 223, 223, 223),
        outlineVariant: const Color.fromARGB(255, 160, 167, 160),
        shadow: Colors.black,
        onSurface: Colors.black);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      pageTransitionsTheme: _pageTransitionsTheme,
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 3,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surfaceContainer,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: colorScheme.surfaceContainer,
          selectedItemColor: colorScheme.onTertiary,
          unselectedItemColor: colorScheme.secondary),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary.withValues()
              : colorScheme.outlineVariant.withValues(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
        surface: const Color.fromARGB(255, 31, 31, 31),
        surfaceContainer: const Color.fromARGB(255, 57, 56, 56),
        onTertiary: const Color.fromARGB(255, 76, 118, 92),
        surfaceContainerHighest: const Color.fromARGB(255, 25, 28, 25),
        primary: const Color.fromARGB(255, 95, 121, 97),
        primaryFixed: Colors.lightBlue,
        outlineVariant: const Color.fromARGB(255, 49, 52, 49),
        onPrimary: const Color.fromARGB(255, 139, 211, 163));

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      pageTransitionsTheme: _pageTransitionsTheme,
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedItemColor: colorScheme.onTertiary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary.withValues()
              : colorScheme.outlineVariant.withValues(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static const PageTransitionsTheme _pageTransitionsTheme =
      PageTransitionsTheme(
    builders: {
      TargetPlatform.android: _CustomPageTransitionsBuilder(),
      TargetPlatform.iOS: _CustomPageTransitionsBuilder(),
      TargetPlatform.windows: _CustomPageTransitionsBuilder(),
      TargetPlatform.macOS: _CustomPageTransitionsBuilder(),
      TargetPlatform.linux: _CustomPageTransitionsBuilder(),
    },
  );
}

class _CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  const _CustomPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.05),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      ),
    );
  }
}
