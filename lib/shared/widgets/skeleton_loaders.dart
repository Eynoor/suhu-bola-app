import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton loading widget untuk table/list items
class SkeletonLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets padding;

  const SkeletonLoader({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 60,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: padding,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: itemHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  /// Rank skeleton
                  Container(
                    width: 30,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]!,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 42),

                  /// Logo skeleton
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]!,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 16),

                  /// Name/Text skeleton
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300]!,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 10,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[300]!,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Stats skeleton
                  SizedBox(
                    width: 30,
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300]!,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300]!,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  /// Badge skeleton
                  Container(
                    width: 35,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]!,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer loading untuk league card
class LeagueCardSkeletonLoader extends StatelessWidget {
  const LeagueCardSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                /// Logo skeleton
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),

                /// Info skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300]!,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 12,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300]!,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300]!,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Arrow skeleton
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
