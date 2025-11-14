import 'package:flutter/material.dart';

class TeamName extends StatelessWidget {
  final String teamName;
  const TeamName({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
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
}
