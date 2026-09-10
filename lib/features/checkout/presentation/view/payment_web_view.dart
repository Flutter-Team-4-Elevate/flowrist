import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({
    super.key,
    required this.paymentUrl,
  });

  final String paymentUrl;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  bool _paymentHandled = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _handleNavigation,
          onWebResourceError: _handleWebResourceError,
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  NavigationDecision _handleNavigation(
    NavigationRequest request,
  ) {
    final uri = Uri.tryParse(request.url);

    if (uri == null) {
      return NavigationDecision.prevent;
    }

    // Payment succeeded.
    if (_isPaymentSuccess(uri)) {
      _completePayment(success: true);

      return NavigationDecision.prevent;
    }

    // Payment cancelled.
    if (_isPaymentCancelled(uri)) {
      _completePayment(success: false);

      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _completePayment({
    required bool success,
  }) {
    // Prevent multiple callbacks from the payment provider.
    if (_paymentHandled) {
      return;
    }

    _paymentHandled = true;

    if (!mounted) {
      return;
    }

    context.pop(success);
  }

  void _handleWebResourceError(
    WebResourceError error,
  ) {
    // Do not consider a WebView resource error a successful payment.
    // Only the configured success URL can complete the payment.
  }

  bool _isPaymentSuccess(Uri uri) {
    return uri.host == 'ahmedusama29.github.io' &&
        uri.path == '/SuccessPage/success.html';
  }

  bool _isPaymentCancelled(Uri uri) {
    return uri.host == 'ahmedusama29.github.io' &&
        uri.path == '/CancelPage/cancel.html';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_paymentHandled,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.payment),
        ),
        body: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
 
