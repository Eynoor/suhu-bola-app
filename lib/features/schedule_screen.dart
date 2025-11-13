// File: lib/features/schedule_screen.dart
// VERSI BARU - DENGAN FILTER (SCHEDULED, LIVE, FINISHED)

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:suhu_bola/core/models/match_model.dart';
import 'package:suhu_bola/core/services/api_service.dart';
import 'package:suhu_bola/shared/widgets/match_card.dart';

// Tipe data baru untuk filter kita
enum MatchStatus { scheduled, live, finished }

class ScheduleScreen extends StatefulWidget {
  final String leagueId;

  const ScheduleScreen({
    super.key,
    required this.leagueId,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late final ApiService _apiService;

  // --- Variabel State Baru ---
  bool _isLoading = true;
  String? _error;

  // 'Master list' untuk menyimpan semua data asli dari API
  List<MatchModel> _allMatches = [];
  // 'Filtered list' untuk ditampilkan di UI
  List<MatchModel> _filteredMatches = [];

  // Status filter yang sedang aktif
  Set<MatchStatus> _selectedFilter = {
    MatchStatus.scheduled
  }; // Default: "Akan Bertanding"
  // -------------------------

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    // Panggil API saat halaman dibuka
    _fetchScheduleData();
  }

  // --- Fungsi Baru: Mengambil data dari API ---
  Future<void> _fetchScheduleData() async {
    try {
      final matches = await _apiService.getScheduleByLeague(widget.leagueId);

      setState(() {
        _allMatches = matches;
        _isLoading = false;
        // Terapkan filter default ("Akan Bertanding")
        _applyFilter();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Gagal memuat jadwal: $e';
      });
    }
  }

  // --- Fungsi Baru: Logika untuk mem-filter 'Master List' ---
  void _applyFilter() {
    // API 'football-data.org' menggunakan status:
    // 'SCHEDULED', 'TIMED' -> Akan Bertanding
    // 'IN_PLAY', 'PAUSED' -> Live
    // 'FINISHED', 'AWARDED' -> Selesai

    _filteredMatches = _allMatches.where((match) {
      if (_selectedFilter.contains(MatchStatus.scheduled) &&
          (match.status == 'SCHEDULED' || match.status == 'TIMED')) {
        return true;
      }
      if (_selectedFilter.contains(MatchStatus.live) &&
          (match.status == 'IN_PLAY' || match.status == 'PAUSED')) {
        return true;
      }
      if (_selectedFilter.contains(MatchStatus.finished) &&
          (match.status == 'FINISHED' || match.status == 'AWARDED')) {
        return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // --- PREMIUM FILTER BUTTONS ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
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
                  child: SegmentedButton<MatchStatus>(
                    style: SegmentedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.grey[400],
                      selectedForegroundColor: Colors.white,
                      selectedBackgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    selected: _selectedFilter,
                    onSelectionChanged: (Set<MatchStatus> newSelection) {
                      if (newSelection.isNotEmpty) {
                        setState(() {
                          _selectedFilter = newSelection;
                          _applyFilter();
                        });
                      }
                    },
                    segments: [
                      ButtonSegment(
                        value: MatchStatus.scheduled,
                        label: Text(
                          'Akan Datang',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        icon: const Icon(Icons.event_note, size: 18),
                      ),
                      ButtonSegment(
                        value: MatchStatus.live,
                        label: Text(
                          'Live',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        icon: const Icon(Icons.live_tv, size: 18),
                      ),
                      ButtonSegment(
                        value: MatchStatus.finished,
                        label: Text(
                          'Selesai',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        icon: const Icon(Icons.check_circle, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- KONTEN LIST ---
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  // --- Widget Baru: Menampilkan konten (Loading/Error/List) ---
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_error!),
        ),
      );
    }

    if (_filteredMatches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tidak ada pertandingan',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    // Tampilkan list yang sudah difilter
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: _filteredMatches.length,
      itemBuilder: (context, index) {
        final match = _filteredMatches[index];
        return MatchCard(match: match);
      },
    );
  }
}
