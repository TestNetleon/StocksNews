import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  final String apiKey;
  final String ticker;

  late WebSocketChannel _channel;
  Function({
    required String price,
    required num change,
    required num percentage,
    required String changeString,
    num? priceValue,
  })? onDataReceived;

  WebSocketService({
    required this.url,
    required this.apiKey,
    required this.ticker,
  });

  void connect() {
    debugPrint("Trying to start SOCKET---");
    _channel = WebSocketChannel.connect(Uri.parse(url));

    // Send login event
    _channel.sink.add(jsonEncode({
      'event': 'login',
      'data': {
        'apiKey': apiKey,
      },
    }));
    debugPrint("Trying to start LOGIN---");

    _channel.stream.listen(
      (message) {
        debugPrint('Received message: $message');
        final data = jsonDecode(message);

        if (data['event'] == 'login' && data['status'] == 200) {
          debugPrint("Login successful");

          // Send subscribe event after login
          _channel.sink.add(jsonEncode({
            'event': 'subscribe',
            'data': {
              'ticker': ticker.toLowerCase(),
            },
          }));
        } else if (data['event'] == 'subscribe' && data['status'] == 200) {
          Utils().showLog(data);
          debugPrint("Subscription successful for ticker: $ticker");
        } else {
          debugPrint("data in else case $data");

          // Handle incoming data
          if (data.containsKey('ap') && data['ap'] != null) {
            final ap = data['ap'];
            final bp = data['bp'];
            final change = (ap - bp);
            final changeString = change.toStringAsFixed(3);

            final percentage = ((ap - bp) / ap * 100);
            debugPrint("AP $ap");
            debugPrint("BP $bp");
            debugPrint("Change $change");
            debugPrint("Percentage $percentage");

            if (onDataReceived != null) {
              onDataReceived!(
                price: '\$${ap.toString()}',
                change: change,
                percentage: percentage,
                changeString: "\$$changeString",
                priceValue: ap,
              );
            }
          }
        }
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
      },
      onDone: () {
        debugPrint('WebSocket closed');
      },
    );
  }

  void unsubscribe() {
    debugPrint('Unsubscribing from ticker: $ticker...');
    var unsubscribeData = {
      "event": "unsubscribe",
      "data": {"ticker": ticker.toLowerCase()}
    };
    _channel.sink.add(jsonEncode(unsubscribeData));
    debugPrint('Un subscription data sent: $unsubscribeData');
  }

  void disconnect() {
    unsubscribe();
    _channel.sink.close();
  }
}
