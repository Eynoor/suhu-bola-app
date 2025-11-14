// File: lib/main.dart
// VERSI FINAL - TEMA PREMIUM + PROVIDER STATE MANAGEMENT

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suhu_bola/features/home/home_screen.dart';
import 'package:suhu_bola/core/theme/app_theme.dart';
import 'package:suhu_bola/core/providers/api_provider.dart';
import 'package:suhu_bola/core/providers/schedule_provider.dart';
import 'package:suhu_bola/core/providers/standings_provider.dart';
import 'package:suhu_bola/core/providers/top_scorers_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // API Service Provider
        ChangeNotifierProvider(create: (_) => ApiServiceProvider()),
        // Schedule Provider
        ChangeNotifierProxyProvider<ApiServiceProvider, ScheduleProvider>(
          create: (context) => ScheduleProvider(
            Provider.of<ApiServiceProvider>(context, listen: false).apiService,
          ),
          update: (context, apiProvider, previous) =>
              previous ?? ScheduleProvider(apiProvider.apiService),
        ),
        // Standings Provider
        ChangeNotifierProxyProvider<ApiServiceProvider, StandingsProvider>(
          create: (context) => StandingsProvider(
            Provider.of<ApiServiceProvider>(context, listen: false).apiService,
          ),
          update: (context, apiProvider, previous) =>
              previous ?? StandingsProvider(apiProvider.apiService),
        ),
        // Top Scorers Provider
        ChangeNotifierProxyProvider<ApiServiceProvider, TopScorersProvider>(
          create: (context) => TopScorersProvider(
            Provider.of<ApiServiceProvider>(context, listen: false).apiService,
          ),
          update: (context, apiProvider, previous) =>
              previous ?? TopScorersProvider(apiProvider.apiService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SUHU BOLA',
        theme: AppTheme.themeData(),
        home: const HomeScreen(),
      ),
    );
  }
}
