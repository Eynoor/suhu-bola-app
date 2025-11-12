// File: lib/features/home/home_screen.dart
// VERSI FINAL - DENGAN PERBAIKAN 'invalid_constant' & 'unused_import'

import 'package:flutter/material.dart';
import 'package:suhu_bola/features/league_detail_screen.dart';
// import 'dart:ui'; // <-- DIHAPUS (unused_import)

// --- AppBar Kustom (terinspirasi .hybrid-2 .header) ---
class _Hybrid2AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _Hybrid2AppBar();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top +
            16.0, // Padding untuk status bar
        left: 24.0,
        right: 24.0,
        bottom: 24.0,
      ),
      // Background AppBar yang sangat gelap
      decoration: BoxDecoration(
        color: const Color(0xFF0a0e1a), // Warna dari .hybrid-2
        border: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.15), // Border aksen
            width: 1.0,
          ),
        ),
      ),
      child: Text(
        'SUHU BOLA',
        style: textTheme.titleLarge?.copyWith(
          fontSize: 28,
          shadows: [
            Shadow(
              color: primaryColor.withOpacity(0.2),
              blurRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0); // Tinggi AppBar
}
// --------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- DATABASE DATA LIGA (DIPERBARUI DENGAN LOGO YANG BENAR) ---
  final List<Map<String, String>> _leagues = [
    {
      'id': '4328',
      'name': 'Premier League',
      'logoUrl':
          'https://upload.wikimedia.org/wikipedia/en/thumb/f/f2/Premier_League_Logo.svg/1200px-Premier_League_Logo.svg.png',
    },
    {
      'id': '4335',
      'name': 'La Liga',
      'logoUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/LaLiga_logo_2023.svg/1200px-LaLiga_logo_2023.svg.png',
    },
    {
      'id': '4332',
      'name': 'Serie A',
      'logoUrl':
          'https://logos-world.net/wp-content/uploads/2025/07/Italian-Serie-A-Logo.png',
    },
    {
      'id': '4331',
      'name': 'Bundesliga',
      'logoUrl':
          'https://upload.wikimedia.org/wikipedia/en/thumb/d/df/Bundesliga_logo_%282017%29.svg/1200px-Bundesliga_logo_%282017%29.svg.png',
    },
    {
      'id': '4334',
      'name': 'Ligue 1',
      'logoUrl':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Ligue_1_2024_Logo.png/960px-Ligue_1_2024_Logo.png',
    },
  ];
  // ----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _Hybrid2AppBar(),
      backgroundColor: const Color(0xFF0a0e1a),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: _leagues.length,
        itemBuilder: (context, index) {
          final league = _leagues[index];
          return _LeagueCard(
            leagueName: league['name']!,
            logoUrl: league['logoUrl']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeagueDetailScreen(
                    leagueId: league['id']!,
                    leagueName: league['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// --- WIDGET KARTU LIGA (DIPERBARUI UNTUK PRESISI & LOGO) ---
class _LeagueCard extends StatefulWidget {
  final String leagueName;
  final String logoUrl;
  final VoidCallback onTap;

  const _LeagueCard({
    required this.leagueName,
    required this.logoUrl,
    required this.onTap,
  });

  @override
  State<_LeagueCard> createState() => _LeagueCardState();
}

class _LeagueCardState extends State<_LeagueCard> {
  bool _isHovered = false;

  void _onHover(bool isHovering) {
    setState(() {
      _isHovered = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final Color cardColor =
        _isHovered ? const Color(0x0D06b6d4) : const Color(0x08FFFFFF);
    final Color borderColor =
        _isHovered ? const Color(0x3306b6d4) : const Color(0x0FFFFFFF);

    // --- PERUBAHAN DI SINI: iconBgColor & iconBorderColor dibuat lebih cerah/kontras ---
    final Color iconBgColor = _isHovered
        ? const Color(0x3306b6d4)
        : const Color(0x3306b6d4); // Sedikit lebih cerah saat tidak hover
    final Color iconBorderColor = _isHovered
        ? const Color(0x6606b6d4)
        : const Color(0x6606b6d4); // Border juga lebih cerah
    // ----------------------------------------------------------------------------------

    final Color arrowColor =
        _isHovered ? primaryColor : const Color(0xFF4b5563);
    final List<BoxShadow> cardShadow = _isHovered
        ? [
            BoxShadow(
                color: const Color(0x1A06b6d4),
                blurRadius: 24,
                offset: const Offset(0, 8))
          ]
        : [];

    const Duration animDuration = Duration(milliseconds: 300);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _onHover(true),
        onTapUp: (_) {
          _onHover(false);
          widget.onTap();
        },
        onTapCancel: () => _onHover(false),
        child: AnimatedContainer(
          duration: animDuration,
          transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Card Body
                AnimatedContainer(
                  duration: animDuration,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: cardColor,
                    border: Border.all(color: borderColor, width: 1),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: cardShadow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- IKON DIPERBARUI (LOGO TIDAK "GEPENG") ---
                      AnimatedContainer(
                        duration: animDuration,
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          border: Border.all(color: iconBorderColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),

                        // --- INI PERBAIKANNYA ---
                        // 'Image.network' dibungkus dengan 'Padding'
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            widget.logoUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error_outline,
                                  color: arrowColor, size: 24);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: primaryColor,
                                ),
                              );
                            },
                          ),
                        ),
                        // ---------------------------------
                      ),
                      // ------------------------------------

                      const SizedBox(width: 16),

                      // Info (.league-info)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.leagueName,
                              style: textTheme.titleMedium
                                  ?.copyWith(letterSpacing: -0.2),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Lihat Jadwal & Klasemen',
                              style: textTheme.bodySmall
                                  ?.copyWith(color: const Color(0xFF6b7280)),
                            ),
                          ],
                        ),
                      ),

                      // Panah (.arrow)
                      AnimatedContainer(
                        duration: animDuration,
                        transform:
                            Matrix4.translationValues(_isHovered ? 4 : 0, 0, 0),
                        child: Icon(Icons.arrow_forward_ios,
                            color: arrowColor, size: 20),
                      ),
                    ],
                  ),
                ),

                // Garis Vertikal (::before)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: animDuration,
                    width: 3,
                    height: _isHovered ? 999 : 0,
                    decoration: BoxDecoration(
                      // --- INI PERBAIKAN 'invalid_constant' ---
                      // 'const' DIHAPUS dari LinearGradient
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          Theme.of(context).colorScheme.secondary
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
