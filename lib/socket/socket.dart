import 'dart:convert';

import 'package:stocks_news_new/utils/utils.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  late IOWebSocketChannel channel;

  void connect() {
    channel = IOWebSocketChannel.connect(
        'wss://websockets.financialmodelingprep.com');

    // Send login event
    channel.sink.add(
        '{"event":"login","data":{"apiKey":"5e5573e6668fcd5327987ab3b912ef3e"}}');

    // Listen for incoming messages
    channel.stream.listen((message) {
      Utils().showLog("--- $message ---");
      // Handle received messages
      Map<String, dynamic> data = jsonDecode(message);

      if (data['status'] == 200) {
        // Update UI with data
        if (data['ap'] != null) {
          var ap = data['ap'];
          var bp = data['bp'];
          var change = (ap - bp).toStringAsFixed(3);
          var per = (((ap - bp) / ap) * 100).toStringAsFixed(3);
          var isPositiveChange = ap - bp > 0;

          Utils().showLog("AP: $ap");
          Utils().showLog("BP: $bp");
          Utils().showLog("Change: $change");
          Utils().showLog("ChangePercentage: $per");
          Utils().showLog("change: $isPositiveChange");
        }

        // Send subscribe event if login is successful
        // Assuming you have a method to subscribe to a ticker
        // replace 'subscribeToTicker' with actual method
        // For example: subscribeToTicker(data['symbol']);
      } else {
        // Handle other cases here if needed
      }
    });
  }

  void subscribe(String ticker) {
    Map<String, dynamic> subscribeData = {
      "event": "subscribe",
      "data": {"ticker": ticker}
    };
    send(jsonEncode(subscribeData));
  }

  void unsubscribe(String ticker) {
    Map<String, dynamic> unsubscribeData = {
      "event": "unsubscribe",
      "data": {"ticker": ticker}
    };
    send(jsonEncode(unsubscribeData));
  }

  void send(String data) {
    channel.sink.add(data);
  }

  void close() {
    channel.sink.close();
  }
}
