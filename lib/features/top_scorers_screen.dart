import 'dart:ui'; // Untuk ImageFilter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suhu_bola/core/models/top_scorer_model.dart';
import 'package:suhu_bola/core/providers/top_scorers_provider.dart';
import 'package:suhu_bola/shared/widgets/skeleton_loaders.dart';

class TopScorersScreen extends StatefulWidget {
  final String leagueId;

  const TopScorersScreen({
    super.key,
    required this.leagueId,
  });

  @override
  State<TopScorersScreen> createState() => _TopScorersScreenState();
}

class _TopScorersScreenState extends State<TopScorersScreen> {
  List<String> _availableSeasons = [];
  late String _selectedSeason;

  @override
  void initState() {
    super.initState();
    _generateSeasonsList();
    _selectedSeason = _availableSeasons.first;
    // Fetch top scorers menggunakan Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TopScorersProvider>().fetchTopScorers(
            widget.leagueId,
            _selectedSeason.substring(
                0, 4), // Mengubah "2023-2024" menjadi "2023"
          );
    });
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

  void _onSeasonChanged(String? newSeason) {
    if (newSeason == null || newSeason == _selectedSeason) return;
    setState(() {
      _selectedSeason = newSeason;
      // Fetch top scorers dengan musim baru menggunakan Provider
      context.read<TopScorersProvider>().fetchTopScorers(
            widget.leagueId,
            _selectedSeason.substring(
                0, 4), // Mengubah "2023-2024" menjadi "2023"
          );
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
              'Pemain',
              style: headerStyle,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              'Gol',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              'Ast',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(
              'Pen',
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

  // Widget Baris Tabel (Premium Styling with Glow Effects)
  Widget _buildScorerRow(
      BuildContext context, TopScorerModel scorer, int index) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    // Logika pewarnaan peringkat (seperti .position.gold/green)
    Color rankColor = Colors.grey[400]!;
    Color rankGlowColor = Colors.grey[400]!;

    if (index == 0) {
      rankColor = const Color(0xFFfbbf24); // Emas
      rankGlowColor = const Color(0xFFfbbf24);
    } else if (index < 3) {
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
                  '${index + 1}',
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
                      if (index < 3)
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
            // Logo Tim dengan Container Gradient
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
                  // border intentionally removed to show clean badge/logo
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: scorer.teamBadgeUrl.isNotEmpty
                      ? Image.network(
                          scorer.teamBadgeUrl,
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
            // Nama Pemain dan Tim
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scorer.playerName,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    scorer.teamName,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Gol - Highlight dengan warna
            SizedBox(
              width: 30,
              child: Text(
                '${scorer.goals}',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: const Color(0xFF4ade80),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Assist - Highlight dengan warna
            SizedBox(
              width: 30,
              child: Text(
                '${scorer.assists}',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Penalti Badge (Premium Style dengan Glow)
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
                  '${scorer.penalties}',
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
                    child: Consumer<TopScorersProvider>(
                      builder: (context, topScorersProvider, _) {
                        final cacheKey =
                            '${widget.leagueId}-${_selectedSeason.substring(0, 4)}';
                        final isLoading =
                            topScorersProvider.isLoading(cacheKey);
                        final error = topScorersProvider.getError(cacheKey);
                        final topScorers =
                            topScorersProvider.getTopScorers(cacheKey);

                        if (isLoading && topScorers.isEmpty) {
                          return SkeletonLoader(
                            itemCount: 10,
                            itemHeight: 70,
                          );
                        }
                        if (error != null) {
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Error: $error'),
                          ));
                        }
                        if (topScorers.isEmpty) {
                          return const Center(
                              child: Text('Tidak ada data top scorer.'));
                        }

                        return Column(
                          children: [
                            // Header Tabel
                            _buildHeaderRow(context),
                            // List Data (Semua dalam 1 halaman)
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: topScorers.length,
                                itemBuilder: (context, index) {
                                  return _buildScorerRow(
                                      context, topScorers[index], index);
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
