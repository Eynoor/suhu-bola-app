// File: lib/shared/widgets/match_card.dart
// VERSI BARU - DENGAN LOGO TIM & FONT YANG DISESUAIKAN

import 'dart:ui'; // Import untuk ImageFilter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suhu_bola/core/models/match_model.dart';

class MatchCard extends StatefulWidget {
  final MatchModel match;

  const MatchCard({super.key, required this.match});

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  bool _isHovered = false;

  void _onHover(bool isHovering) {
    setState(() {
      _isHovered = isHovering;
    });
  }

  // --- HELPER UNTUK FORMAT TANGGAL + HARI ---
  String _getFormattedDateTime(String dateStr, String timeStr) {
    try {
      final dateTimeParts = dateStr.split('-');
      final timeParts = timeStr.split(':');

      final dateTime = DateTime(
        int.parse(dateTimeParts[0]),
        int.parse(dateTimeParts[1]),
        int.parse(dateTimeParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      return DateFormat('EEE, dd MMM HH:mm').format(dateTime);
    } catch (e) {
      return '$dateStr $timeStr';
    }
  }

  // --- WIDGET: Badge (HOME/AWAY) ---
  Widget _buildTeamBadge(BuildContext context, {required bool isHome}) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHome
              ? [primaryColor.withOpacity(0.3), primaryColor.withOpacity(0.15)]
              : [
                  secondaryColor.withOpacity(0.3),
                  secondaryColor.withOpacity(0.15)
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isHome
              ? primaryColor.withOpacity(0.5)
              : secondaryColor.withOpacity(0.5),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isHome ? 'HOME' : 'AWAY',
        style: textTheme.labelSmall?.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: isHome ? primaryColor : secondaryColor,
        ),
      ),
    );
  }

  // --- WIDGET UNTUK LOGO SAJA (BESAR, TANPA BORDER) ---
  Widget _buildTeamLogo(BuildContext context, {required String logoUrl}) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: 70,
      height: 70,
      child: Center(
        child: Image.network(
          logoUrl,
          fit: BoxFit.contain,
          width: 70,
          height: 70,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.sports_soccer,
              color: primaryColor,
              size: 50,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- WIDGET UNTUK NAMA TIM (DIBAWAH LOGO) ---
  Widget _buildTeamName(BuildContext context, {required String teamName}) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      teamName,
      textAlign: TextAlign.center,
      style: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 0.3,
        color: Colors.white,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // ---------------------------------------------

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    String scoreOrTime;
    bool isMatchPlayed = widget.match.status == 'FINISHED' ||
        (widget.match.homeScore != null && widget.match.awayScore != null);
    bool isLive =
        widget.match.status == 'LIVE' || widget.match.status == 'IN_PLAY';

    if (isMatchPlayed) {
      scoreOrTime = "${widget.match.homeScore} - ${widget.match.awayScore}";
    } else if (isLive) {
      scoreOrTime = "LIVE";
    } else {
      scoreOrTime = widget.match.time.substring(0, 5);
    }

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _isHovered
                        ? primaryColor.withOpacity(0.1)
                        : Colors.white.withOpacity(0.04),
                    _isHovered
                        ? secondaryColor.withOpacity(0.06)
                        : Colors.white.withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isHovered
                      ? primaryColor.withOpacity(0.3)
                      : Colors.white.withOpacity(0.08),
                  width: 1.5,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.2),
                          blurRadius: 24,
                          spreadRadius: 1,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- ROW 1: TEAM BADGES (DI ATAS LOGO) ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Tim Tuan Rumah Badge
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: _buildTeamBadge(context, isHome: true),
                        ),
                      ),

                      // Spacer for center score box
                      const SizedBox(width: 120),

                      // Tim Tamu Badge
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: _buildTeamBadge(context, isHome: false),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // --- ROW 2: LOGOS (BIG) - SCORE - LOGOS (BIG) [VS EFFECT] ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo Tim Tuan Rumah
                      _buildTeamLogo(
                        context,
                        logoUrl: widget.match.homeTeamLogoUrl,
                      ),

                      // Kotak Skor/Waktu
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 120,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isHovered
                                ? [
                                    primaryColor.withOpacity(0.3),
                                    secondaryColor.withOpacity(0.2),
                                  ]
                                : [
                                    primaryColor.withOpacity(0.1),
                                    primaryColor.withOpacity(0.05),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: _isHovered
                                ? primaryColor.withOpacity(0.4)
                                : primaryColor.withOpacity(0.2),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _isHovered
                              ? [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.25),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              scoreOrTime,
                              textAlign: TextAlign.center,
                              style: textTheme.titleMedium?.copyWith(
                                fontSize: isLive ? 18 : 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                                color: isMatchPlayed
                                    ? primaryColor
                                    : isLive
                                        ? const Color(0xFFef4444)
                                        : Colors.white,
                                shadows: _isHovered
                                    ? [
                                        Shadow(
                                          color: primaryColor.withOpacity(0.3),
                                          blurRadius: 8,
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                            if (isLive)
                              Column(
                                children: [
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFef4444),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFef4444)
                                              .withOpacity(0.6),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      // Logo Tim Tamu
                      _buildTeamLogo(
                        context,
                        logoUrl: widget.match.awayTeamLogoUrl,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // --- ROW: TEAM NAMES (DIBAWAH LOGO) ---
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: _buildTeamName(context,
                              teamName: widget.match.homeTeam),
                        ),
                      ),

                      // spacer aligned with score box width
                      const SizedBox(width: 120),

                      Expanded(
                        child: Center(
                          child: _buildTeamName(context,
                              teamName: widget.match.awayTeam),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // --- ROW 3: STATUS BADGE (DI BAWAH SKOR) ---
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isMatchPlayed
                              ? [
                                  primaryColor.withOpacity(0.2),
                                  primaryColor.withOpacity(0.08),
                                ]
                              : isLive
                                  ? [
                                      const Color(0xFFef4444).withOpacity(0.25),
                                      const Color(0xFFef4444).withOpacity(0.1),
                                    ]
                                  : [
                                      secondaryColor.withOpacity(0.2),
                                      secondaryColor.withOpacity(0.08),
                                    ],
                        ),
                        border: Border.all(
                          color: isMatchPlayed
                              ? primaryColor.withOpacity(0.5)
                              : isLive
                                  ? const Color(0xFFef4444).withOpacity(0.7)
                                  : secondaryColor.withOpacity(0.5),
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isMatchPlayed
                            ? 'SELESAI'
                            : isLive
                                ? 'LIVE'
                                : 'MENDATANG',
                        style: textTheme.labelSmall?.copyWith(
                          color: isMatchPlayed
                              ? primaryColor
                              : isLive
                                  ? const Color(0xFFef4444)
                                  : secondaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- DIVIDER GRADIENT ---
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withOpacity(0.1),
                          primaryColor.withOpacity(0.3),
                          primaryColor.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- ROW 4: DATE/TIME + DAY (PALING BAWAH) ---
                  Center(
                    child: Text(
                      _getFormattedDateTime(
                          widget.match.date, widget.match.time),
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[300],
                        fontSize: 11,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
