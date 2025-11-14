import 'package:flutter/material.dart';

class TeamLogo extends StatelessWidget {
  final String logoUrl;
  const TeamLogo({super.key, required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    // If URL is empty, show placeholder icon immediately without loading
    if (logoUrl.isEmpty) {
      return SizedBox(
        width: 70,
        height: 70,
        child: Center(
          child: Icon(
            Icons.sports_soccer,
            color: primaryColor,
            size: 50,
          ),
        ),
      );
    }

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
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
