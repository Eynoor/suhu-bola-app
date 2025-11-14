import 'package:flutter/material.dart';

/// Widget untuk menampilkan logo dengan container yang animated dan styled
class LogoContainer extends StatelessWidget {
  final String logoUrl;
  final bool isHovered;
  final Color primaryColor;
  final Color secondaryColor;

  const LogoContainer({
    super.key,
    required this.logoUrl,
    required this.isHovered,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    const Duration animDuration = Duration(milliseconds: 400);

    return AnimatedContainer(
      duration: animDuration,
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.2),
            secondaryColor.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isHovered
              ? primaryColor.withOpacity(0.5)
              : primaryColor.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: isHovered ? 16 : 8,
            spreadRadius: isHovered ? 2 : 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.network(
          logoUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.sports_soccer,
              color: primaryColor,
              size: 40,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
