// File: lib/features/schedule_screen.dart
// VERSI REFACTORED - MENGGUNAKAN PROVIDER STATE MANAGEMENT

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suhu_bola/core/models/match_model.dart';
import 'package:suhu_bola/core/providers/schedule_provider.dart';
import 'package:suhu_bola/shared/widgets/match_card.dart';

// Tipe data untuk filter
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
  // --- Filter State ---
  Set<MatchStatus> _selectedFilter = {MatchStatus.scheduled};

  @override
  void initState() {
    super.initState();
    // Fetch data menggunakan Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleProvider>().fetchSchedule(widget.leagueId);
    });
  }

  /// Terapkan filter ke list matches
  List<MatchModel> _filterMatches(List<MatchModel> matches) {
    return matches.where((match) {
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

          // --- CONTENT LIST ---
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan konten (Loading/Error/List)
  Widget _buildContent() {
    return Consumer<ScheduleProvider>(
      builder: (context, scheduleProvider, _) {
        final isLoading = scheduleProvider.isLoading(widget.leagueId);
        final error = scheduleProvider.getError(widget.leagueId);
        final allMatches = scheduleProvider.getSchedule(widget.leagueId);
        final filteredMatches = _filterMatches(allMatches);

        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Gagal memuat jadwal: $error'),
            ),
          );
        }

        if (filteredMatches.isEmpty) {
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
          itemCount: filteredMatches.length,
          itemBuilder: (context, index) {
            final match = filteredMatches[index];
            return MatchCard(match: match);
          },
        );
      },
    );
  }
}
