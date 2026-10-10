import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_cubit.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_events.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/category_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryRailSection extends StatelessWidget {
  final CategoryRailPayloadEntity payload;

  const CategoryRailSection({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: localizations.categories,
          onViewAll: () {
            // context.push(AppRoutes.categoriesTab);
            StatefulNavigationShell.of(context).goBranch(1);
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoriesTabView()));
          },
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: payload.items.length,
            separatorBuilder: (_, _) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (context, index) {
              final item = payload.items[index];

              return GestureDetector(
                onTap: () {
                  context.read<CategoriesCubit>().doEvent(
                    GetCategoriesEvent(targetCategoryId: item.id),
                  );

                  StatefulNavigationShell.of(context).goBranch(1);
                },
                child: SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: item.iconUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Container(
                              width: 64,
                              height: 64,
                              color: AppColors.white50,
                              child: const Icon(Icons.broken_image_outlined),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
