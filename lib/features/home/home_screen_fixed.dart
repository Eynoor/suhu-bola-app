// File: lib/features/home/home_screen.dart
// VERSI REFACTORED - DENGAN EXTRACTED SUB-WIDGETS (TASK 4: PREFER COMPOSITION)

import 'package:flutter/material.dart';
import 'package:suhu_bola/features/league_detail_screen.dart';
import 'package:suhu_bola/shared/widgets/league_card/league_logo_container.dart';
import 'package:suhu_bola/shared/widgets/league_card/league_info.dart';
import 'package:suhu_bola/shared/widgets/league_card/action_button.dart';
import 'package:suhu_bola/shared/widgets/league_card/hover_line.dart';
import 'dart:ui';

// --- AppBar Kustom Premium dengan Gradient & Visual Effects ---
class _Hybrid2AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _Hybrid2AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(140.0);

  Widget _buildTitleWithGlow(
    TextTheme textTheme,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Stack(
      children: [
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
    );
  }

  Widget _buildSubtitle(
    TextTheme textTheme,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Row(
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
    );
  }

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
          _buildTitleWithGlow(textTheme, primaryColor, secondaryColor),
          const SizedBox(height: 8),
          _buildSubtitle(textTheme, primaryColor, secondaryColor),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    const Duration animDuration = Duration(milliseconds: 400);

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
          transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
          margin: const EdgeInsets.symmetric(vertical: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Stack(
                children: [
                  _buildCardBackground(
                    primaryColor,
                    secondaryColor,
                    animDuration,
                  ),
                  HoverLine(
                    isHovered: _isHovered,
                    animDuration: animDuration,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBackground(
    Color primaryColor,
    Color secondaryColor,
    Duration animDuration,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _isHovered
                ? primaryColor.withOpacity(0.12)
                : Colors.white.withOpacity(0.05),
            _isHovered
                ? secondaryColor.withOpacity(0.08)
                : Colors.white.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: _isHovered
              ? primaryColor.withOpacity(0.4)
              : Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.25),
                  blurRadius: 28,
                  spreadRadius: 1,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: secondaryColor.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LeagueLogoContainer(
            logoUrl: widget.logoUrl,
            isHovered: _isHovered,
            animDuration: animDuration,
          ),
          const SizedBox(width: 24),
          LeagueInfo(
            leagueName: widget.leagueName,
            isHovered: _isHovered,
          ),
          const SizedBox(width: 16),
          ActionButton(
            isHovered: _isHovered,
            animDuration: animDuration,
          ),
        ],
      ),
    );
  }
}
