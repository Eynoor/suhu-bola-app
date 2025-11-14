import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData themeData() {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData.dark().copyWith(
      textTheme: textTheme.copyWith(
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Colors.white,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: Colors.white.withOpacity(0.9),
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: Colors.grey[400],
        ),
        labelSmall: textTheme.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey[500],
          letterSpacing: 1,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundMedium,
        elevation: 0,
        centerTitle: false,
      ),
      tabBarTheme: TabBarTheme(
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.white,
      ),
    );
  }
}
