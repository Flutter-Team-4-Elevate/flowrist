import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/occasion_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OccasionRailSection extends StatelessWidget {
  final OccasionRailPayloadEntity payload;

  const OccasionRailSection({super.key, required this.payload});

  void _openOccasion(
    BuildContext context, {
    required String occasionId,
    required int initialIndex,
  }) {
    context.push(
      AppRoutes.occasions,
      extra: {'occasionId': occasionId, 'initialIndex': initialIndex},
    );
  }

  void _openAllOccasions(BuildContext context) {
    context.push(AppRoutes.occasions);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (payload.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: localizations.occasion,
          onViewAll: () {
            _openAllOccasions(context);
          },
        ),

        const SizedBox(height: 4),

        SizedBox(
          height: 210,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.defaultScreenPadding,
              vertical: 10,
            ),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: payload.items.length,
            separatorBuilder: (_, _) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (context, index) {
              final item = payload.items[index];

              return SizedBox(
                width: 160,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    _openOccasion(
                      context,
                      occasionId: item.id,
                      initialIndex: index,
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,

                            placeholder: (context, url) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: AppColors.white50,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
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

                      const SizedBox(height: 8),

                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.medium18Inter.copyWith(fontSize: 15),
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
