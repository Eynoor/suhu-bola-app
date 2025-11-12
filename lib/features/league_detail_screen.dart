// File: lib/features/league_detail_screen.dart
// VERSI FINAL - GRADIENT HEADER & PILL TABS (PERBAIKAN WARNA)

import 'package:flutter/material.dart';
import 'package:suhu_bola/features/schedule_screen.dart';
import 'package:suhu_bola/features/standings_screen.dart';
import 'package:suhu_bola/features/top_scorers_screen.dart';
import 'dart:ui'; // Untuk ImageFilter

// Ini adalah AppBar kustom kita yang terinspirasi dari HTML
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
      // Padding atas untuk AppBar
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 16, right: 16),
      decoration: BoxDecoration(
        // Gradient seperti di .header
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tombol Kembali Kaca (seperti .back-btn)
          SafeArea(
            bottom: false, // Penting agar tidak ada padding berlebih di bawah
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2), // PUTIH transparan
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 1.5),
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white), // Ikon putih
                  ),
                ),
              ),
            ),
          ),

          const Spacer(), // Dorong judul ke bawah

          // Judul (seperti .header-title)
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
                fontSize: 28, color: Colors.white), // PASTIKAN WARNA TEKS PUTIH
          ),

          const SizedBox(height: 16),

          // TabBar (seperti .tabs)
          Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black
                  .withOpacity(0.2), // Latar belakang pil (hitam transparan)
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: tabController,
              // 'indicator' (pil putih) dan 'labelColor' (teks gelap)
              // sudah diatur di main.dart
              tabs: const [
                Tab(text: 'KLASEMEN'), // Tab pertama sekarang Klasemen
                Tab(text: 'JADWAL'),
                Tab(text: 'TOP SCORE'),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(200); // Tinggi AppBar kustom kita
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
