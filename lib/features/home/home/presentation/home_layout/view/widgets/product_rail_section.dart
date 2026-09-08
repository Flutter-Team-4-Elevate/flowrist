import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/product_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/section_title.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/shimmer_widgets/product_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductRailSection extends StatelessWidget {
  final ProductRailPayloadEntity payload;

  const ProductRailSection({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: localizations.bestSellers,
          onViewAll: () {
            context.push(AppRoutes.bestSeller);
          },
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: payload.items.length,
            separatorBuilder: (_, _) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (context, index) {
              final item = payload.items[index];

              return SizedBox(
                width: 160,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    debugPrint('Product tapped: ${item.id}');

                    context.push(AppRoutes.productDetailsPath(item.id));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return const ProductCardShimmer();
                            },
                            errorWidget: (context, url, error) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: AppColors.white50,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.regular12Inter.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
