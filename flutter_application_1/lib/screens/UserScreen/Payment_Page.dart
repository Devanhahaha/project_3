import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String snapToken;


  const PaymentPage({Key? key, required this.snapToken}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Inisialisasi WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (url.contains('finish')) {
              Navigator.pop(context, 'success');
            } else if (url.contains('error')) {
              Navigator.pop(context, 'error');
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(
        "https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}",
      ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Midtrans'),
        backgroundColor: Colors.blueAccent,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
