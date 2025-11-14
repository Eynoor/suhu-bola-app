// File: lib/features/home/home_screen.dart
// VERSI FINAL - DENGAN PERBAIKAN 'invalid_constant' & 'unused_import'

import 'package:flutter/material.dart';
import 'package:suhu_bola/features/league_detail_screen.dart';
import 'package:suhu_bola/shared/widgets/league_card/league_card.dart';

// --- AppBar Kustom Premium dengan Gradient & Visual Effects ---
class _Hybrid2AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _Hybrid2AppBar();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20.0,
        left: 24.0,
        right: 24.0,
        bottom: 32.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0a0e1a),
            const Color(0xFF0f172a).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul utama dengan efek glow
          Stack(
            children: [
              // Efek blur di belakang (glow effect)
              Text(
                'SUHU BOLA',
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: primaryColor.withOpacity(0.3),
                  shadows: [
                    Shadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 30,
                    ),
                    Shadow(
                      color: secondaryColor.withOpacity(0.2),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
              // Teks utama di depan
              Text(
                'SUHU BOLA',
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: primaryColor.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Subtitle dengan aksen warna
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Liga Sepak Bola Terbaik Dunia',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[400],
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140.0); // Tinggi AppBar
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
          return LeagueCard(
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
