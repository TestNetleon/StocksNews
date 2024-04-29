import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stocks_news_new/providers/qr_code_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class QRcodeContainer extends StatefulWidget {
  const QRcodeContainer({super.key});

  @override
  State<QRcodeContainer> createState() => _QRcodeContainerState();
}

//
class _QRcodeContainerState extends State<QRcodeContainer> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;

  @override
  void initState() {
    super.initState();
    _type();
  }

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller?.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller?.resumeCamera();
  //   }
  // }

  void _type() {
    log("00");
    if (Platform.isAndroid) {
      log("11");

      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      log("22");

      controller?.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    log("0");
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      log("1");

      setState(() {
        result = scanData;

        log("RESULT ${result?.code}");
      });

      if (result?.code != null) {
        controller.stopCamera();
        context.read<QRcodePRovider>().getQRdata(qrCode: result?.code ?? "");
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appbar: const AppBarHome(isPopback: true, showTrailing: false),
      body: QRView(
        onPermissionSet: (p0, p1) {
          if (!p1) {
            controller?.stopCamera();
            // controller?.dispose();
            Navigator.pop(context);
          }
        },
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
