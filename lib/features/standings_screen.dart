// File: lib/features/standings_screen.dart
// VERSI BARU - TABEL KACA & LENCANA POIN

import 'dart:ui'; // Untuk ImageFilter
import 'package:flutter/material.dart';
import 'package:suhu_bola/core/models/standings_model.dart';
import 'package:suhu_bola/core/services/api_service.dart';

class StandingsScreen extends StatefulWidget {
  final String leagueId;

  const StandingsScreen({
    super.key,
    required this.leagueId,
  });

  @override
  State<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  late final ApiService _apiService;
  Future<List<StandingsModel>>? _standingsFuture;

  List<String> _availableSeasons = [];
  late String _selectedSeason;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _generateSeasonsList();
    _selectedSeason = _availableSeasons.first;
    _fetchStandings();
  }

  void _generateSeasonsList() {
    _availableSeasons = [];
    final now = DateTime.now();
    int currentSeasonEndYear = (now.month >= 8) ? now.year + 1 : now.year;
    for (int i = 0; i < 10; i++) {
      int endYear = currentSeasonEndYear - i;
      int startYear = endYear - 1;
      _availableSeasons.add('$startYear-$endYear');
    }
  }

  void _fetchStandings() {
_standingsFuture = _apiService.getStandingsByLeague(
  widget.leagueId,
  _selectedSeason.substring(0, 4), // Mengubah "2023-2024" menjadi "2023"
);
  }

  void _onSeasonChanged(String? newSeason) {
    if (newSeason == null || newSeason == _selectedSeason) return;
    setState(() {
      _selectedSeason = newSeason;
      _fetchStandings();
    });
  }

  // Widget Header Tabel (terinspirasi .table-header)
  Widget _buildHeaderRow(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.labelSmall;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          SizedBox(
              width: 30,
              child: Text('#', style: headerStyle, textAlign: TextAlign.center)),
          const SizedBox(width: 42), // Spasi logo
          Expanded(
            flex: 3,
            child: Text('Tim', style: headerStyle, textAlign: TextAlign.left),
          ),
          SizedBox(
              width: 30, child: Text('M', style: headerStyle, textAlign: TextAlign.center)),
          SizedBox(
              width: 30, child: Text('W', style: headerStyle, textAlign: TextAlign.center)),
          SizedBox(
              width: 30, child: Text('D', style: headerStyle, textAlign: TextAlign.center)),
          SizedBox(
              width: 30, child: Text('L', style: headerStyle, textAlign: TextAlign.center)),
          SizedBox(
              width: 35,
              child: Text('Pts', style: headerStyle, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  // Widget Baris Tabel (terinspirasi .table-row)
  Widget _buildTeamRow(BuildContext context, StandingsModel team, int index) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    // Logika pewarnaan peringkat (seperti .position.gold/green)
    Color rankColor = Colors.grey[400]!;
    if (team.rank == 1) {
      rankColor = const Color(0xFFfbbf24); // Emas
    } else if (team.rank <= 4) {
      rankColor = const Color(0xFF4ade80); // Hijau
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Peringkat
          SizedBox(
            width: 30,
            child: Text(
              '${team.rank}',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: rankColor,
                shadows: [
                  BoxShadow(color: rankColor.withOpacity(0.3), blurRadius: 8)
                ]
              ),
            ),
          ),
          // Logo
          SizedBox(
            width: 42,
            child: team.teamBadgeUrl.isNotEmpty
                ? Image.network(
                    team.teamBadgeUrl, width: 24, height: 24,
                    errorBuilder: (c, e, s) => const Icon(Icons.shield_outlined, size: 24, color: Colors.grey),
                  )
                : const Icon(Icons.shield_outlined, size: 24, color: Colors.grey),
          ),
          // Nama Tim
          Expanded(
            flex: 3,
            child: Text(
              team.teamName,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Statistik (M, W, D, L)
          SizedBox(
              width: 30,
              child: Text('${team.played}',
                  style: textTheme.bodySmall, textAlign: TextAlign.center)),
          SizedBox(
              width: 30,
              child: Text('${team.wins}',
                  style: textTheme.bodySmall, textAlign: TextAlign.center)),
          SizedBox(
              width: 30,
              child: Text('${team.draws}',
                  style: textTheme.bodySmall, textAlign: TextAlign.center)),
          SizedBox(
              width: 30,
              child: Text('${team.losses}',
                  style: textTheme.bodySmall, textAlign: TextAlign.center)),
          // Lencana Poin (seperti .points-badge)
          SizedBox(
            width: 35,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Text(
                '${team.points}',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Ikut background gradient
      body: Column(
        children: [
          // --- WIDGET FILTER MUSIM (Glassmorphism) ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Musim',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      DropdownButton<String>(
                        value: _selectedSeason,
                        onChanged: _onSeasonChanged,
                        dropdownColor: const Color(0xFF1e293b), // Medium Slate
                        style: Theme.of(context).textTheme.bodyMedium,
                        underline: Container(),
                        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary),
                        items: _availableSeasons.map((String season) {
                          return DropdownMenuItem<String>(
                            value: season,
                            child: Text(season),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // --- KONTEN TABEL (Glassmorphism) ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05), // Kaca super tipis
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
                    ),
                    child: FutureBuilder<List<StandingsModel>>(
                      future: _standingsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Error: ${snapshot.error}'),
                          ));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Tidak ada data klasemen.'));
                        }

                        final standings = snapshot.data!;

                        return Column(
                          children: [
                            // Header Tabel (di dalam container kaca)
                            _buildHeaderRow(context),
                            // List Data
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero, // Hapus padding
                                itemCount: standings.length,
                                itemBuilder: (context, index) {
                                  return _buildTeamRow(context, standings[index], index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}