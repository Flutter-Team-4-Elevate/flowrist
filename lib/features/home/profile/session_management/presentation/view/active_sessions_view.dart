import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/cubit/sessions_cubit.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/cubit/sessions_events.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/cubit/sessions_state.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/view/widgets/session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveSessionsView extends StatefulWidget {
  const ActiveSessionsView({super.key});

  @override
  State<ActiveSessionsView> createState() => _ActiveSessionsViewState();
}

class _ActiveSessionsViewState extends State<ActiveSessionsView> {
  @override
  void initState() {
    super.initState();
    context.read<SessionsCubit>().doEvent(const GetSessionsEvent());
  }

  void _confirmRevokeSession(BuildContext context, String sessionId) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.revokeSessionTitle, style: AppStyles.medium18Inter),
        content: Text(
          l10n.revokeSessionConfirmation,
          style: AppStyles.regular14Inter,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(l10n.cancel, style: AppStyles.regular14Inter),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<SessionsCubit>().doEvent(
                RevokeSessionEvent(sessionId),
              );
            },
            child: Text(
              l10n.revoke,
              style: AppStyles.medium16Inter.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      appBar: AppBar(
        title: Text(l10n.activeSessions, style: AppStyles.medium20),
        centerTitle: true,
        backgroundColor: AppColors.whiteBase,
        elevation: 0,
      ),
      body: BlocConsumer<SessionsCubit, SessionsState>(
        listenWhen: (previous, current) =>
            previous.successMessage != current.successMessage ||
            previous.sessions.errorMessage != current.sessions.errorMessage,
        listener: (context, state) {
          if (state.sessions.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.sessions.errorMessage!),
                backgroundColor: AppColors.red,
              ),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.sessionRevokedSuccessfully),
                backgroundColor: AppColors.purpleBase,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.sessions != current.sessions ||
            previous.revokingSessionId != current.revokingSessionId,
        builder: (context, state) {
          if (state.sessions.isLoading && state.sessions.data == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.purpleBase),
            );
          }

          final sessions = state.sessions.data ?? [];

          if (sessions.isEmpty) {
            return Center(
              child: Text(
                l10n.noActiveSessions,
                style: AppStyles.regular14Inter,
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.purpleBase,
            onRefresh: () async {
              context.read<SessionsCubit>().doEvent(const GetSessionsEvent());
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                AppDimensions.defaultScreenPadding,
                AppDimensions.defaultScreenPadding,
                AppDimensions.defaultScreenPadding,
                AppDimensions.defaultScreenPadding + bottomInset,
              ),
              itemCount: sessions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final session = sessions[index];
                final isRevoking = state.revokingSessionId == session.id;

                return SessionCard(
                  session: session,
                  isRevoking: isRevoking,
                  onRevoke: () => _confirmRevokeSession(context, session.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
