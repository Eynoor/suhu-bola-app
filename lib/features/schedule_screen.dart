// File: lib/features/schedule_screen.dart
// VERSI BARU - DENGAN FILTER (SCHEDULED, LIVE, FINISHED)

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
  Set<MatchStatus> _selectedFilter = {MatchStatus.scheduled}; // Default: "Akan Bertanding"
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
    return Scaffold(
      backgroundColor: Colors.transparent, // Ikut background gradient
      body: Column(
        children: [
          // --- UI FILTER BARU (SegmentedButton) ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SegmentedButton<MatchStatus>(
              // Style agar sesuai tema premium
              style: SegmentedButton.styleFrom(
                backgroundColor: const Color(0xFF1e293b).withOpacity(0.5), // Medium Slate (transparan)
                foregroundColor: Colors.grey[400],
                selectedForegroundColor: Colors.white,
                selectedBackgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              // Filter yang sedang aktif
              selected: _selectedFilter,
              // Update state saat tombol diganti
              onSelectionChanged: (Set<MatchStatus> newSelection) {
                if (newSelection.isNotEmpty) { // Pastikan tidak kosong
                  setState(() {
                    _selectedFilter = newSelection;
                    _applyFilter(); // Terapkan filter baru
                  });
                }
              },
              // Pilihan filter
              segments: const [
                ButtonSegment(
                  value: MatchStatus.scheduled,
                  label: Text('Akan Datang'),
                  icon: Icon(Icons.event),
                ),
                ButtonSegment(
                  value: MatchStatus.live,
                  label: Text('Live'),
                  icon: Icon(Icons.settings_input_antenna),
                ),
                ButtonSegment(
                  value: MatchStatus.finished,
                  label: Text('Selesai'),
                  icon: Icon(Icons.check_circle),
                ),
              ],
            ),
          ),
          
          // --- KONTEN LIST (Menggantikan FutureBuilder) ---
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
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_error!),
      ));
    }

    if (_filteredMatches.isEmpty) {
      return const Center(child: Text('Tidak ada pertandingan.'));
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