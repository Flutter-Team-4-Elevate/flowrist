import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductImageSliverAppBar extends StatelessWidget {
  final List<String> images;
  final double expandedHeight;
  final PageController pageController;
  final int currentImageIndex;
  final ValueChanged<int> onPageChanged;

  const ProductImageSliverAppBar({
    super.key,
    required this.images,
    required this.expandedHeight,
    required this.pageController,
    required this.currentImageIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.whiteBase,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.blackBase,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;
          final delta = top - kToolbarHeight;
          final totalExpand = expandedHeight - kToolbarHeight;
          final expandRatio = (delta / totalExpand).clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (images.isEmpty)
                  _buildPlaceholder()
                else
                  Transform.scale(
                    scale: 0.85 + (0.15 * expandRatio),
                    child: Opacity(
                      opacity: expandRatio,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: images.length,
                        onPageChanged: onPageChanged,
                        itemBuilder: (context, index) => Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, _, _) => _buildPlaceholder(),
                        ),
                      ),
                    ),
                  ),
                if (images.length > 1 && expandRatio > 0.2)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (index) {
                        final isSelected = currentImageIndex == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isSelected
                                ? AppColors.purpleBase
                                : AppColors.white60,
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.whiteBase,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 60,
          color: AppColors.white70,
        ),
      ),
    );
  }
}
