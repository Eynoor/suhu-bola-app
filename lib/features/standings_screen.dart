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

  // Widget Header Tabel (Premium Styling)
  Widget _buildHeaderRow(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.primary,
        );
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.08),
            primaryColor.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '#',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 42), // Spasi logo
          Expanded(
            flex: 3,
            child: Text(
              'Tim',
              style: headerStyle,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              'M',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              'W',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              'D',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              'L',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(
              'Pts',
              style: headerStyle?.copyWith(
                color: primaryColor.withOpacity(0.8),
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Widget Baris Tabel (Premium Styling with Hover Effects)
  Widget _buildTeamRow(BuildContext context, StandingsModel team, int index) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    // Logika pewarnaan peringkat (seperti .position.gold/green)
    Color rankColor = Colors.grey[400]!;
    Color rankGlowColor = Colors.grey[400]!;

    if (team.rank == 1) {
      rankColor = const Color(0xFFfbbf24); // Emas
      rankGlowColor = const Color(0xFFfbbf24);
    } else if (team.rank <= 4) {
      rankColor = const Color(0xFF4ade80); // Hijau
      rankGlowColor = const Color(0xFF4ade80);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.03),
            Colors.white.withOpacity(0.01),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: [
            // Peringkat dengan Glow
            SizedBox(
              width: 30,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '${team.rank}',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: rankColor,
                    fontSize: 14,
                    shadows: [
                      BoxShadow(
                        color: rankGlowColor.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                      if (team.rank <= 4)
                        BoxShadow(
                          color: rankGlowColor.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Logo dengan Container Gradient
            SizedBox(
              width: 42,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.1),
                      secondaryColor.withOpacity(0.05),
                    ],
                  ),
                  // border removed so team badge appears without stroke
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: team.teamBadgeUrl.isNotEmpty
                      ? Image.network(
                          team.teamBadgeUrl,
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => Icon(
                            Icons.shield_outlined,
                            size: 20,
                            color: primaryColor.withOpacity(0.6),
                          ),
                        )
                      : Icon(
                          Icons.shield_outlined,
                          size: 20,
                          color: primaryColor.withOpacity(0.6),
                        ),
                ),
              ),
            ),
            // Nama Tim
            Expanded(
              flex: 3,
              child: Text(
                team.teamName,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Statistik (M, W, D, L) - Lebih highlight
            SizedBox(
              width: 30,
              child: Text(
                '${team.played}',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 30,
              child: Text(
                '${team.wins}',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: const Color(0xFF4ade80),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 30,
              child: Text(
                '${team.draws}',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 30,
              child: Text(
                '${team.losses}',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: const Color(0xFFef4444),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Lencana Poin (Premium Style dengan Glow)
            SizedBox(
              width: 35,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  '${team.points}',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Musim',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      DropdownButton<String>(
                        value: _selectedSeason,
                        onChanged: _onSeasonChanged,
                        dropdownColor: const Color(0xFF1e293b), // Medium Slate
                        style: Theme.of(context).textTheme.bodyMedium,
                        underline: Container(),
                        icon: Icon(Icons.arrow_drop_down,
                            color: Theme.of(context).colorScheme.primary),
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
                      border: Border.all(
                          color: Colors.white.withOpacity(0.1), width: 1.5),
                    ),
                    child: FutureBuilder<List<StandingsModel>>(
                      future: _standingsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Error: ${snapshot.error}'),
                          ));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('Tidak ada data klasemen.'));
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
                                  return _buildTeamRow(
                                      context, standings[index], index);
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
