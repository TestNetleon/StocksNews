import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/utils.dart';

import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/progress_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/constants.dart';
import '../tabs/tabs.dart';

class WebviewLink extends StatefulWidget {
  final Uri? url;
  final String? stringURL;
  final String? notificationId;
  const WebviewLink({
    super.key,
    this.url,
    this.stringURL,
    this.notificationId,
  });

  @override
  State<WebviewLink> createState() => _AnalysisForecastState();
}

//
class _AnalysisForecastState extends State<WebviewLink> {
  WebViewController controller = WebViewController();
  bool loading = false;
  @override
  void initState() {
    super.initState();
    Utils().showLog("-------${widget.url}---- ${widget.stringURL}---------");
    _setData(url: widget.url, stringURL: widget.stringURL);
  }

  setLoading(value) {
    loading = value;
    setState(() {});
  }

  void _setData({Uri? url, String? stringURL}) {
    Utils().showLog('navigated url: $url');
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            Utils().showLog("progress $progress");
          },
          onPageStarted: (String url) {
            setLoading(true);
            Utils().showLog("page finished $url");
          },
          onPageFinished: (String url) {
            setLoading(false);
            Utils().showLog("page finished $url");
          },
          onWebResourceError: (WebResourceError error) {
            setLoading(false);
          },
        ),
      )
      ..loadRequest(
          (stringURL != null && stringURL != "") ? Uri.parse(stringURL) : url!);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        try {
          if (popHome) {
            Future.delayed(const Duration(milliseconds: 50), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Tabs.path, (route) => false);
              popHome = false;
            });
          }
        } catch (e) {
          //
        }
      },
      child: BaseContainer(
        appBar: const AppBarHome(
          isPopback: true,
          canSearch: true,
        ),
        body: loading
            ? const ProgressDialog()
            : WebViewWidget(
                controller: controller,
              ),
      ),
    );
  }
}
