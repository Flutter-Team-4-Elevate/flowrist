import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/banner_payload_entity.dart';
import 'package:flutter/material.dart';

class BannerSection extends StatelessWidget {
  final BannerPayloadEntity payload;

  const BannerSection({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 6,
          child: CachedNetworkImage(
            imageUrl: payload.imageUrl,
            fit: BoxFit.cover,

            // Loading state
            // placeholder: (context, url) {
            //   return Container(
            //     width: double.infinity,
            //     height: double.infinity,
            //     color: AppColors.white50,
            //     child: const Center(
            //       child: CircularProgressIndicator(),
            //     ),
            //   );
            // },

            // Error state
            errorWidget: (context, url, error) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.white50,
                child: const Center(
                  child: Icon(Icons.broken_image_outlined, size: 40),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
