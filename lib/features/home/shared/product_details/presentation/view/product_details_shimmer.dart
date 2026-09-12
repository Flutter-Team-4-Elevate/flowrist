import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.white),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Row: Price + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _box(width: 130, height: 24),
                    _box(width: 100, height: 18),
                  ],
                ),
                const SizedBox(height: 8),
                _box(width: 110, height: 14), // All prices include tax
                const SizedBox(height: 16),
                _box(width: 220, height: 20), // Product Name
                const SizedBox(height: 24),
                _box(width: 100, height: 18), // Description Title
                const SizedBox(height: 10),
                _box(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                _box(width: 260, height: 14),
                const SizedBox(height: 24),
                _box(width: 130, height: 18), // Bouquet include Title
                const SizedBox(height: 10),
                _box(width: 140, height: 14),
                const SizedBox(height: 8),
                _box(width: 100, height: 14),
                const SizedBox(height: 40),
                _box(width: double.infinity, height: 50, radius: 25), // Button
              ]),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _box({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
