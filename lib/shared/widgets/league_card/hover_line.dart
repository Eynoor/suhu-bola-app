import 'package:flutter/material.dart';

class HoverLine extends StatelessWidget {
  final bool isHovered;
  final Duration animDuration;

  const HoverLine({
    super.key,
    required this.isHovered,
    required this.animDuration,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: animDuration,
        width: isHovered ? 4 : 0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(isHovered ? 8 : 0),
            bottomRight: Radius.circular(isHovered ? 8 : 0),
          ),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
