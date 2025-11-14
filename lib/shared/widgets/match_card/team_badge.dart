import 'package:flutter/material.dart';

class TeamBadge extends StatelessWidget {
  final bool isHome;
  const TeamBadge({super.key, required this.isHome});

  @override
  Widget build(BuildContext context) {
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
}
