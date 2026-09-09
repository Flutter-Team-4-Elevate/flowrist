import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView({super.key});

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  bool isNotificationEnabled = true;

  static const Color pinkPrimary = Color(0xFFD81B60);
  static const Color iconGrey = Color(0xFF555555);
  static const Color borderGrey = Color(0xFFE5E5E5);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // const Text('🌸', style: TextStyle(fontSize: 18)),
                      SvgPicture.asset(
                        AppImages.appLogo,
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.flowery,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: pinkPrimary,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.black87,
                          size: 26,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Profile Header
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Avatar
                    CircleAvatar(
                      radius: 42,
                      child: SvgPicture.asset(
                        AppImages.appLogo,
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // User Name with Edit Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hesham Mohamed",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // User Email
                    Text(
                      "hesham133@1elevate.com",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 24),

                    // First Section: Orders & Address
                    _buildSection([
                      _buildListTile(
                        icon: Icons.assignment_outlined,
                        title: l10n.myOrders,
                        onTap: () {
                          context.push(AppRoutes.myOrders);
                        },
                      ),
                      _buildListTile(
                        icon: Icons.location_on_outlined,
                        title: l10n.saveAddress,
                        onTap: () {
                          context.push(AppRoutes.savedAddresses);
                        },
                      ),
                      _buildListTile(
                        icon: Icons.location_on_outlined,
                        title: l10n.activeSessions,
                        onTap: () {
                          context.push(AppRoutes.activeSessions);
                        },
                      ),
                    ]),

                    // Second Section: Notifications
                    _buildSection([
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        leading: Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: isNotificationEnabled,
                            activeColor: Colors.white,
                            activeTrackColor: pinkPrimary,
                            onChanged: (val) {
                              setState(() => isNotificationEnabled = val);
                            },
                          ),
                        ),
                        title: Text(
                          l10n.notification,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: iconGrey,
                          size: 20,
                        ),
                      ),
                    ]),

                    // Third Section: Settings & Info
                    _buildSection([
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        leading: const Icon(
                          Icons.translate,
                          color: iconGrey,
                          size: 20,
                        ),
                        title: Text(
                          l10n.language,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Text(
                          l10n.current_language,
                          style: const TextStyle(
                            fontSize: 13,
                            color: pinkPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {},
                      ),
                      _buildListTile(title: l10n.about_us, onTap: () {}),
                      _buildListTile(
                        title: l10n.terms_and_conditions,
                        onTap: () {},
                      ),
                    ]),

                    // Fourth Section: Logout
                    _buildSection([
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        leading: const Icon(
                          Icons.logout,
                          color: iconGrey,
                          size: 20,
                        ),
                        title: Text(
                          l10n.logOut,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.logout,
                          color: iconGrey,
                          size: 20,
                        ),
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // App Version Footer
                    Text(
                      l10n.app_version,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Divider wrapped section list
  Widget _buildSection(List<Widget> children) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: borderGrey, width: 0.8),
          bottom: BorderSide(color: borderGrey, width: 0.8),
        ),
      ),
      child: Column(children: children),
    );
  }

  // Generic List Tile Item
  Widget _buildListTile({
    IconData? icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: icon != null ? Icon(icon, color: iconGrey, size: 20) : null,
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: iconGrey, size: 20),
      onTap: onTap,
    );
  }
}
