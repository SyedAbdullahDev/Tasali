import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermConditonsScreen extends StatefulWidget {
  const TermConditonsScreen({super.key});

  @override
  State<TermConditonsScreen> createState() => _TermConditonsScreenState();
}

class _TermConditonsScreenState extends State<TermConditonsScreen> {
   final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(initialUrl: '',onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
         gestureNavigationEnabled: true,
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },),
    );
  }
}
