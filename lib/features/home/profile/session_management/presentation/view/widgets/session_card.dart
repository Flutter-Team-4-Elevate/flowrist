import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/profile/session_management/domain/entities/session_entity.dart';
import 'package:flutter/material.dart';

class SessionCard extends StatelessWidget {
  final SessionEntity session;
  final bool isRevoking;
  final VoidCallback onRevoke;

  const SessionCard({
    super.key,
    required this.session,
    required this.isRevoking,
    required this.onRevoke,
  });

  IconData _resolveDeviceIcon(String deviceName) {
    final lower = deviceName.toLowerCase();
    if (lower.contains('windows') ||
        lower.contains('mac') ||
        lower.contains('linux') ||
        lower.contains('chrome')) {
      return Icons.laptop_mac_outlined;
    }
    return Icons.phone_android_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deviceTitle = session.deviceName.isEmpty
        ? AppConstants.unknownDevice
        : session.deviceName;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: session.isCurrent ? AppColors.lightPink : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: session.isCurrent ? AppColors.purpleBase : AppColors.white60,
          width: session.isCurrent ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: session.isCurrent
                  ? AppColors.purpleBase.withValues(alpha: 0.15)
                  : AppColors.white50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: session.isCurrent
                    ? AppColors.purpleBase
                    : AppColors.white60,
                width: 0.6,
              ),
            ),
            child: Icon(
              _resolveDeviceIcon(session.deviceName),
              color: session.isCurrent
                  ? AppColors.purpleBase
                  : AppColors.blackBase,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        deviceTitle,
                        style: AppStyles.medium16InterBlack,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (session.isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.purpleBase,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.currentSession,
                          style: AppStyles.medium16Inter.copyWith(
                            fontSize: 11,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                if (session.ipAddress.isNotEmpty)
                  Text(session.ipAddress, style: AppStyles.regular13Grey),
                const SizedBox(height: 4),
                Text(
                  session.isCurrent ? l10n.activeNow : session.createdAt,
                  style: session.isCurrent
                      ? AppStyles.regular13.copyWith(
                          color: AppColors.purpleBase,
                          fontWeight: FontWeight.w500,
                        )
                      : AppStyles.regular13Grey,
                ),
              ],
            ),
          ),
          if (!session.isCurrent) ...[
            const SizedBox(width: 8),
            if (isRevoking)
              const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.red,
                  ),
                ),
              )
            else
              IconButton(
                onPressed: onRevoke,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.red,
                  size: 22,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
