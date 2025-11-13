// File: lib/features/league_detail_screen.dart
// VERSI FINAL - GRADIENT HEADER & PILL TABS (PERBAIKAN WARNA)

import 'package:flutter/material.dart';
import 'package:suhu_bola/features/schedule_screen.dart';
import 'package:suhu_bola/features/standings_screen.dart';
import 'package:suhu_bola/features/top_scorers_screen.dart';
import 'dart:ui'; // Untuk ImageFilter

// Premium AppBar untuk League Detail Screen
class PremiumLeagueAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final TabController tabController;

  const PremiumLeagueAppBar({
    super.key,
    required this.title,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0a0e1a),
            const Color(0xFF0f172a).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button - Premium Style
          SafeArea(
            bottom: false,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.2),
                      secondaryColor.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: primaryColor,
                  size: 22,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Title dengan Glow Effect
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: primaryColor.withOpacity(0.4),
                  blurRadius: 12,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Premium TabBar dengan Glassmorphism
          Container(
            height: 48,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 12,
                ),
              ],
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              labelStyle: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: const [
                Tab(text: 'KLASEMEN'),
                Tab(text: 'JADWAL'),
                Tab(text: 'TOP SCORERS'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(220);
}

// --- Halaman Utama (di-refactor) ---
class LeagueDetailScreen extends StatefulWidget {
  final String leagueId;
  final String leagueName;

  const LeagueDetailScreen({
    super.key,
    required this.leagueId,
    required this.leagueName,
  });

  @override
  State<LeagueDetailScreen> createState() => _LeagueDetailScreenState();
}

class _LeagueDetailScreenState extends State<LeagueDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita gunakan AppBar kustom baru kita
      appBar: PremiumLeagueAppBar(
        title: widget.leagueName,
        tabController: _tabController,
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          // PENTING: Urutan diubah agar KLASEMEN jadi tab pertama
          StandingsScreen(leagueId: widget.leagueId),
          ScheduleScreen(leagueId: widget.leagueId),
          TopScorersScreen(leagueId: widget.leagueId),
        ],
      ),
    );
  }
}
