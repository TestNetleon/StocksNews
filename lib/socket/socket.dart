import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  final String apiKey;
  final String ticker;

  late WebSocketChannel _channel;
  Function(String price, num change, num percentage, String changeString)?
      onDataReceived;

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
                '\$${ap.toString()}',
                change,
                percentage,
                "\$$changeString",
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

// class CryptoWebSocket {
//   final String apiKey;
//   final String ticker;
//   final String url = 'wss://crypto.financialmodelingprep.com';
//   late final WebSocketChannel channel;

//   late double ap;
//   late double bp;
//   late String change;
//   late String percentage;

//   CryptoWebSocket({required this.apiKey, required this.ticker}) {
//     debugPrint('Initializing WebSocket connection...');
//     channel = IOWebSocketChannel.connect(url);
//     login();
//     subscribe();
//     channel.stream.listen(
//       _onData,
//       onError: _onError,
//       onDone: _onDone,
//     );
//   }

//   void login() {
//     debugPrint('Logging in with API key...');
//     var loginData = {
//       "event": "login",
//       "data": {"apiKey": apiKey}
//     };
//     channel.sink.add(jsonEncode(loginData));
//     debugPrint('Login data sent: $loginData');
//   }

//   void subscribe() {
//     debugPrint('Subscribing to ticker: $ticker...');
//     var subscribeData = {
//       "event": "subscribe",
//       "data": {"ticker": ticker}
//     };
//     channel.sink.add(jsonEncode(subscribeData));
//     debugPrint('Subscription data sent: $subscribeData');
//   }

//   void unsubscribe() {
//     debugPrint('Unsubscribing from ticker: $ticker...');
//     var unsubscribeData = {
//       "event": "unsubscribe",
//       "data": {"ticker": ticker}
//     };
//     channel.sink.add(jsonEncode(unsubscribeData));
//     debugPrint('Un subscription data sent: $unsubscribeData');
//   }

//   void _onData(dynamic data) {
//     debugPrint('Data received: $data');
//     Map<String, dynamic> decodedData = jsonDecode(data);

//     if (decodedData.containsKey('event')) {
//       String event = decodedData['event'];
//       switch (event) {
//         case 'login':
//           debugPrint('Login response: $decodedData');
//           break;
//         case 'subscribe':
//           debugPrint('Subscribe response: $decodedData');
//           break;
//         case 'unsubscribe':
//           debugPrint('Unsubscribe response: $decodedData');
//           break;
//         default:
//           debugPrint('Unknown event: $decodedData');
//           break;
//       }
//     } else if (decodedData['s'] == ticker) {
//       ap = decodedData['ap'];
//       bp = decodedData['bp'];
//       double changeValue = ap - bp;
//       change = changeValue.toStringAsFixed(3);
//       double percentageValue = (changeValue / ap * 100);
//       percentage = percentageValue.toStringAsFixed(3);
//       debugPrint("AP $ap");
//       debugPrint("BP $bp");
//       debugPrint("Change $change");
//       debugPrint("Percentage $percentage");
//     }
//   }

//   void _onError(Object error) {
//     debugPrint('WebSocket error: $error');
//   }

//   void _onDone() {
//     debugPrint('WebSocket connection closed.');
//   }

//   void close() {
//     debugPrint('Closing WebSocket connection...');
//     unsubscribe();
//     channel.sink.close();
//     debugPrint('WebSocket connection closed.');
//   }
// }
