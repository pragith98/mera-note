import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdsterraBannerAd extends StatefulWidget {
  const AdsterraBannerAd({super.key});

  @override
  State<AdsterraBannerAd> createState() => _AdsterraBannerAdState();
}

class _AdsterraBannerAdState extends State<AdsterraBannerAd> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse('https://boisterous-tiramisu-b337d2.netlify.app'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 50, child: WebViewWidget(controller: _controller));
  }
}
