import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const AppWebViewScreen({super.key, required this.title, required this.url});

  @override
  State<AppWebViewScreen> createState() => _AppWebViewScreenState();
}

class _AppWebViewScreenState extends State<AppWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.whiteBase)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (error) {
            if (error.isForMainFrame ?? true) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _reload() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      appBar: AppBar(
        title: Text(widget.title, style: AppStyles.medium18Inter),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.blackBase,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        bottom: _isLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(
                  color: AppColors.purpleBase,
                  backgroundColor: AppColors.white60,
                ),
              )
            : null,
      ),
      body: _hasError
          ? _buildErrorView(l10n)
          : WebViewWidget(controller: _controller),
    );
  }

  Widget _buildErrorView(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: AppColors.grey30,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.generalValidationError,
              style: AppStyles.medium16InterBlack,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.connectionErrorMessage,
              textAlign: TextAlign.center,
              style: AppStyles.regular14Inter,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _reload, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
