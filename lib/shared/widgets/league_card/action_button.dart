import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final bool isHovered;
  final Duration animDuration;

  const ActionButton({
    super.key,
    required this.isHovered,
    required this.animDuration,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return AnimatedContainer(
      duration: animDuration,
      transform: Matrix4.translationValues(isHovered ? 6 : 0, 0, 0),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isHovered
                ? [primaryColor, secondaryColor]
                : [
                    primaryColor.withOpacity(0.2),
                    secondaryColor.withOpacity(0.15),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Icon(
          Icons.arrow_forward_rounded,
          color: isHovered ? Colors.white : primaryColor.withOpacity(0.6),
          size: 24,
        ),
      ),
    );
  }
}
