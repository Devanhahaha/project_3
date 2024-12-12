import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/utils/const.dart';

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


// Future<void> _updateTransactionStatus(String status) async {
//     const String baseUrl = '$host/api';
//     final response = await http.post(
//       Uri.parse('$baseUrl/pulsa/callback'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'order_id': widget.snapToken, // Atau ID order yang relevan
//         'transaction_status': status, // Status transaksi (settlement, cancel, pending, dll)
//       }),
//     );

//     if (response.statusCode == 200) {
//       print("Status transaksi berhasil diperbarui");
//     } else {
//       print("Gagal memperbarui status transaksi");
//     }
//   }


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
