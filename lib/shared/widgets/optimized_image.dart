import 'package:flutter/material.dart';

/// Optimized image widget dengan precaching dan fade-in animation
class OptimizedImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Duration animationDuration;
  final Widget? errorBuilder;
  final BorderRadius borderRadius;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
    this.animationDuration = const Duration(milliseconds: 500),
    this.errorBuilder,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  State<OptimizedImage> createState() => _OptimizedImageState();
}

class _OptimizedImageState extends State<OptimizedImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // Precache image dan mulai animasi saat loaded
    if (widget.imageUrl.isNotEmpty && widget.imageUrl.startsWith('http')) {
      precacheImage(
        NetworkImage(widget.imageUrl),
        context,
      ).then((_) {
        if (mounted) {
          _fadeController.forward();
        }
      }).catchError((_) {
        if (mounted) {
          _fadeController.forward();
        }
      });
    } else {
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[300]!,
          borderRadius: widget.borderRadius,
        ),
        child: widget.errorBuilder ??
            Icon(
              Icons.image_not_supported,
              color: Colors.grey[600],
            ),
      );
    }

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Image.network(
          widget.imageUrl,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey[300],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: widget.borderRadius,
              ),
              child: widget.errorBuilder ??
                  Icon(
                    Icons.broken_image,
                    color: Colors.grey[600],
                  ),
            );
          },
        ),
      ),
    );
  }
}
