import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/loading.dart';

class PdfViewerWidget extends StatefulWidget {
  final String url;

  const PdfViewerWidget({super.key, required this.url});

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadFile(widget.url);
  }

  // Future<void> _downloadFile(String url) async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final filePath = '${directory.path}/temp.pdf';
  //     Utils().showLog('File Path $filePath');
  //     final response = await http.get(Uri.parse(url));
  //     print('Response status: ${response.statusCode}');
  //     if (response.statusCode == 200) {
  //       final file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);
  //       print('File written successfully: $filePath');
  //     } else {
  //       print('Failed to download file with status: ${response.statusCode}');
  //     }

  //     setState(() {
  //       localPath = filePath;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error downloading file: $e');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> _downloadFile(String url) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/temp.pdf';
      Utils().showLog('File Path: $filePath');

      final response = await http.get(Uri.parse(url));
      Utils().showLog('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        Utils().showLog('File written successfully: $filePath');

        if (await file.exists()) {
          setState(() {
            localPath = filePath;
            isLoading = false;
          });
        } else {
          Utils().showLog('File does not exist after writing.');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        Utils().showLog(
            'Failed to download file with status: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Utils().showLog('Error downloading file: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('${widget.url}');

    return BaseScaffold(
      appBar: const BaseAppBar(showBack: true),
      body: isLoading
          ? const Center(child: Loading())
          : SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: PDFView(
                filePath: localPath ?? '',
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: false,
                onRender: (pages) {
                  setState(() {});
                },
                onError: (error) {},
                onPageError: (page, error) {},
              ),
            ),
    );
  }
}
