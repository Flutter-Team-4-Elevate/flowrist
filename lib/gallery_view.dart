import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_strings.dart';
import 'package:flowrist/core/ui/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'core/constants/app_styles.dart';
import 'core/constants/flowery_icons.dart';

const List<IconData> _icons = [
  Icons.visibility_off_outlined,
  Icons.error_outline,
  Icons.arrow_back_ios_new,
  Icons.check_outlined,
  Icons.home_outlined,
  Icons.category_outlined,
  Icons.shopping_cart_outlined,
  Icons.person_outline,
  Icons.location_on,
  Icons.search_outlined,
  FloweryIcons.tulip,
  FloweryIcons.gift,
  FloweryIcons.gift_box,
  FloweryIcons.diamond,
  Icons.tune,
  FloweryIcons.delete,
  Icons.remove_outlined,
  Icons.add,
  Icons.sort_outlined,
  FloweryIcons.address,
  FloweryIcons.location,
  Icons.photo_camera_outlined,
  FloweryIcons.alarm_clock,
  FloweryIcons.heart_eyes,
  Icons.translate_outlined,
  Icons.logout_outlined,
  FloweryIcons.flag_britain,
  FloweryIcons.flag_japan,
  FloweryIcons.flag_germany,
  FloweryIcons.flag_france,
  FloweryIcons.flag_usa,
  FloweryIcons.flag_egypt,
  FloweryIcons.star,
  FloweryIcons.home,
  FloweryIcons.delivery_boy,
  Icons.call_outlined,
  Icons.chat_outlined,
  FloweryIcons.delivery_motorcycle,
  FloweryIcons.blue_location,
  FloweryIcons.delivery_boy,
  Icons.file_upload_outlined,
  FloweryIcons.checklist,
  Icons.fact_check_outlined,
  Icons.schedule_outlined,
  Icons.payments_outlined,
  Icons.cancel_outlined,
  Icons.check_circle_outline,
  FloweryIcons.processing,
];

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.defaultScreenPadding,
        vertical: 8,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildIconsGrid(),
            const SizedBox(height: 20),
            _buildAppTitle(),
            const SizedBox(height: 20),
            _buildTextsView(),
            const SizedBox(height: 20),
            _buildAppButtons(),
            const SizedBox(height: 20),
            _buildAppTextField(localizations),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildIconsGrid() {
    return SizedBox(
      height: 370,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemBuilder: (context, index) =>
            InkWell(onTap: () {}, child: Icon(_icons[index])),
        itemCount: _icons.length,
      ),
    );
  }

  Widget _buildAppTitle() {
    return InkWell(
      onTap: () {
        AppRouter.router.go(AppRoutes.homeTab);
      },
      child: Row(
        children: [
          SvgPicture.asset(AppImages.appLogo, height: 30),
          const SizedBox(width: 10),
          Text(AppStrings.appName, style: AppStyles.appTitle),
          const SizedBox(width: 20),
          Text('Go Home', style: AppStyles.medium16Roboto),
        ],
      ),
    );
  }

  Widget _buildTextsView() {
    return Column(
      children: [
        Text('Regular 12 Roboto', style: AppStyles.regular12Roboto),
        Text('Regular 12 Inter', style: AppStyles.regular12Inter),
        Text('Regular 12 Underline', style: AppStyles.regular12Underline),
        Text('Regular 13', style: AppStyles.regular13),
        Text('Regular 14 Roboto', style: AppStyles.regular14Roboto),
        Text('Regular 14 Inter', style: AppStyles.regular14Inter),
        Text('Regular 16', style: AppStyles.regular16),
        Text('Medium 16 Roboto', style: AppStyles.medium16Roboto),
        Text('Medium 16 Inter', style: AppStyles.medium16Inter),
        Text('Medium 18 Roboto', style: AppStyles.medium18Roboto),
        Text('Medium 18 Inter', style: AppStyles.medium18Inter),
        Text('Medium 20', style: AppStyles.medium20),
        Text('Semi Bold 12 Underline', style: AppStyles.semiBold12Underline),
      ],
    );
  }

  Widget _buildAppButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Elevated Button'),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            child: Text('Outlined Button'),
          ),
        ),
      ],
    );
  }

  Widget _buildAppTextField(AppLocalizations localizations) => AppTextField(
    label: 'Email',
    hint: 'Enter your email',
    localizations: localizations,
  );
}
