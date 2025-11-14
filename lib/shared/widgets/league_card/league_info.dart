import 'package:flutter/material.dart';

class LeagueInfo extends StatelessWidget {
  final String leagueName;
  final bool isHovered;

  const LeagueInfo({
    super.key,
    required this.leagueName,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // League name with glow effect
          Text(
            leagueName,
            style: textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: Colors.white,
              shadows: isHovered
                  ? [
                      Shadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle with accent line
          Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Lihat Jadwal, Klasemen & Top Scorer',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                    fontSize: 13,
                    letterSpacing: 0.2,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
