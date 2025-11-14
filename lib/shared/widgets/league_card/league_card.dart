import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:suhu_bola/shared/widgets/league_card/league_logo_container.dart';
import 'package:suhu_bola/shared/widgets/league_card/league_info.dart';
import 'package:suhu_bola/shared/widgets/league_card/action_button.dart';
import 'package:suhu_bola/shared/widgets/league_card/hover_line.dart';

/// Main card widget untuk menampilkan informasi liga
/// Menggunakan sub-widget yang terkomposisi untuk setiap bagian
class LeagueCard extends StatefulWidget {
  final String leagueName;
  final String logoUrl;
  final VoidCallback onTap;

  const LeagueCard(
      {super.key,
      required this.leagueName,
      required this.logoUrl,
      required this.onTap});

  @override
  State<LeagueCard> createState() => _LeagueCardState();
}

class _LeagueCardState extends State<LeagueCard> {
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
                  // Background Card dengan Gradient
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    decoration: _buildCardDecoration(
                      primaryColor,
                      secondaryColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo Container
                        LeagueLogoContainer(
                          logoUrl: widget.logoUrl,
                          isHovered: _isHovered,
                          animDuration: animDuration,
                        ),

                        const SizedBox(width: 24),

                        // League Info
                        LeagueInfo(
                          leagueName: widget.leagueName,
                          isHovered: _isHovered,
                        ),

                        const SizedBox(width: 16),

                        // Action Button
                        ActionButton(
                          isHovered: _isHovered,
                          animDuration: animDuration,
                        ),
                      ],
                    ),
                  ),

                  // Hover Line Effect
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

  /// Build decoration untuk card container
  BoxDecoration _buildCardDecoration(Color primary, Color secondary) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          _isHovered
              ? primary.withOpacity(0.12)
              : Colors.white.withOpacity(0.05),
          _isHovered
              ? secondary.withOpacity(0.08)
              : Colors.white.withOpacity(0.02),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: _isHovered
            ? primary.withOpacity(0.4)
            : Colors.white.withOpacity(0.1),
        width: 1.5,
      ),
      boxShadow: _isHovered
          ? [
              BoxShadow(
                color: primary.withOpacity(0.25),
                blurRadius: 28,
                spreadRadius: 1,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: secondary.withOpacity(0.1),
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
    );
  }
}
