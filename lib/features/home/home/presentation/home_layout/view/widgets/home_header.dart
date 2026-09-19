import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/delivery_location_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: SvgPicture.asset(
                    AppImages.appLogo,
                    height: 24,
                    width: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Text(localizations.flowery, style: AppStyles.appTitle),
                const SizedBox(width: 17),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextFormField(
                      readOnly: true,
                      onTap: () {
                        context.push(AppRoutes.search);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.white70,
                          size: 24,
                        ),
                        hintText: localizations.search,
                        hintStyle: AppStyles.regular14Roboto,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.white70,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.white70,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const DeliveryLocationHeader(),
          ],
        ),
      ),
    );
  }
}
