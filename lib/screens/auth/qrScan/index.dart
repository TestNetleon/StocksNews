import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/qr_code_provider.dart';
import 'package:stocks_news_new/screens/auth/qrScan/container.dart';

class QrScan extends StatelessWidget {
  static const path = "QrScan";
  const QrScan({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: QRcodePRovider(), child: const QRcodeContainer());
  }
}
//