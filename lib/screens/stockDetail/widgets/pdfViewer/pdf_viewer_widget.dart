import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/loading.dart';

class PdfViewerWidget extends StatefulWidget {
  final String url;

  const PdfViewerWidget({super.key, required this.url});

  @override
  _PdfViewerWidgetState createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadFile(widget.url);
  }

  Future<void> _downloadFile(String url) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/temp.pdf';
      final response = await http.get(Uri.parse(url));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        localPath = filePath;
        isLoading = false;
      });
    } catch (e) {
      // print('Error downloading file: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: isLoading
          ? const Center(child: Loading())
          : PDFView(
              filePath: localPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: false,
              onRender: (pages) {
                setState(() {});
              },
              onError: (error) {
                // print(error.toString());
              },
              onPageError: (page, error) {
                // print('$page: ${error.toString()}');
              },
            ),
    );
  }
}
