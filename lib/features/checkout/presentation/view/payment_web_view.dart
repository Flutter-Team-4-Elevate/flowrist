import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
 
class PaymentWebView extends StatefulWidget {
  const PaymentWebView({super.key, required this.paymentUrl});
  final String paymentUrl;
  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isPaymentCompleted = false;
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
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
         
            if (!mounted) return;
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    if (uri == null) {
      return NavigationDecision.prevent;
    }
   
    if (_isPaymentSuccess(uri)) {
   
      if (_isPaymentCompleted) {
        return NavigationDecision.prevent;
      }
      _isPaymentCompleted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pop(true);
      });
      return NavigationDecision.prevent;
    }
    if (_isPaymentCancelled(uri)) {
     
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pop(false);
      });
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
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
      canPop: !_isPaymentCompleted,
      child: Scaffold(
        appBar: AppBar(title: Text(localizations.payment)),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
