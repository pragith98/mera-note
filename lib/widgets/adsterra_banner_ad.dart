import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdsterraBannerAd extends StatefulWidget {
  const AdsterraBannerAd({super.key});

  @override
  State<AdsterraBannerAd> createState() => _AdsterraBannerAdState();
}

class _AdsterraBannerAdState extends State<AdsterraBannerAd> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) => setState(() => _isLoading = true),
              onPageFinished: (url) => setState(() => _isLoading = false),
              onWebResourceError: (error) {
                debugPrint('WebView error: ${error.description}');
                setState(() => _isLoading = false);
              },
            ),
          )
          ..loadRequest(
            Uri.parse('https://boisterous-tiramisu-b337d2.netlify.app'),
          );
  }

  void reloadAd() {
    if (mounted) {
      setState(() => _isLoading = true);
      _controller.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }
}
