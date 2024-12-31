import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:stocks_news_new/utils/utils.dart';

class SSEManager {
  static final SSEManager _instance = SSEManager._internal();
  factory SSEManager() => _instance;

  final Dio dio = Dio();
  final Map<String, Function(StockDataManagerRes)> _listeners = {};
  final Map<String, StreamSubscription?> _streamSubscriptions = {};

  // Private constructor
  SSEManager._internal();

  // Public method to add listeners
  void addListener(String symbol, Function(StockDataManagerRes) listener) {
    _listeners[symbol] = listener;
  }

  // Public method to remove listeners
  void removeListener(String symbol) {
    _listeners.remove(symbol);
  }

  void connectToSSE(String symbol) {
    const baseUrl = 'https://dev.stocks.news';

    for (int port = 8021; port == 8021; port++) {
      Utils().showLog('PORT ON $port');
      final url = '$baseUrl:$port/symbolData?symbol=$symbol';

      print('Attempting to connect to SSE at $url');

      dio
          .get<ResponseBody>(
        url,
        options: Options(responseType: ResponseType.stream),
      )
          .then((response) {
        final subscription = response.data?.stream.listen((event) {
          final rawData = String.fromCharCodes(event);
          Utils().showLog('Raw data for $symbol : $rawData');

          if (rawData.startsWith('{')) {
            try {
              final data = Map<String, dynamic>.from(json.decode(rawData));
              print('Data for $symbol: $data');

              if (data.containsKey('price') &&
                  data.containsKey('change') &&
                  data.containsKey('changePercentage')) {
                final stockData = StockDataManagerRes(
                  price: data['price'] as double,
                  change: data['change'] as double,
                  changePercentage: data['changePercentage'] as double,
                );

                if (_listeners.containsKey(symbol)) {
                  _listeners[symbol]!(stockData);
                }
              } else {
                print('Unexpected data format for $symbol: $data');
              }
            } catch (e) {
              print('Error parsing SSE data for $symbol: $e');
            }
          } else {
            print('Received non-JSON data for $symbol: $rawData');
          }
        }, onError: (error) {
          print('Stream error for $symbol: $error');
        }, cancelOnError: true);

        _streamSubscriptions[symbol] = subscription;
      }).catchError((error) {
        if (error is DioException) {
          print(
              'Failed to connect to SSE for $symbol. HTTP status: ${error.response?.statusCode}. Error: ${error.message}');
        } else {
          print('Unknown error while connecting to SSE for $symbol: $error');
        }
      });
    }
  }

  // Disconnect from a specific SSE connection by symbol
  void disconnect(String symbol) {
    final subscription = _streamSubscriptions[symbol];
    if (subscription != null) {
      subscription.cancel(); // Cancel the subscription for this symbol
      _streamSubscriptions
          .remove(symbol); // Remove the subscription from the map
      print('Disconnected from SSE for $symbol');
    } else {
      print('No active SSE connection for $symbol');
    }
  }

  // Disconnect from all SSE connections
  void disconnectAll() {
    _streamSubscriptions.forEach((symbol, subscription) {
      subscription?.cancel(); // Cancel the subscription for each symbol
      print('Disconnected from SSE for $symbol');
    });

    // Clear the subscriptions map
    _streamSubscriptions.clear();
    print('All SSE connections have been disconnected.');
  }
}

class StockDataManagerRes {
  final num? price;
  final num? change;
  final num? changePercentage;

  StockDataManagerRes({
    this.price,
    this.change,
    this.changePercentage,
  });
}

// import 'dart:convert';
// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// class SSEManager {
//   // Singleton instance
//   static final SSEManager _instance = SSEManager._internal();
//   factory SSEManager() => _instance;

//   final Dio dio = Dio();
//   final Map<int, StreamSubscription?> _streamSubscriptions =
//       {}; // To hold the active subscriptions

//   // Private constructor
//   SSEManager._internal();

//   void connectToSSE() {
//     const baseUrl = 'https://dev.stocks.news';

//     // Loop through ports from 8021 to 8036
//     for (int port = 8036; port <= 8036; port++) {
//       Utils().showLog('PORT ON $port');
//       final url = '$baseUrl:$port/sse';

//       print('Attempting to connect to SSE at $url');

//       dio
//           .get<ResponseBody>(
//         url,
//         options: Options(responseType: ResponseType.stream),
//       )
//           .then((response) {
//         final subscription = response.data?.stream.listen((event) {
//           final rawData = String.fromCharCodes(event);

//           // Remove the "data: " prefix if it exists
//           final cleanedData =
//               rawData.startsWith("data: ") ? rawData.substring(6) : rawData;

//           if (cleanedData.startsWith("{") || cleanedData.startsWith("[")) {
//             try {
//               final data = Map<String, dynamic>.from(json.decode(cleanedData));
//               Utils().showLog('Raw data: $data');
//             } catch (e) {
//               print('Error parsing JSON: $e');
//             }
//           } else {
//             Utils().showLog('Received non-JSON data: $cleanedData');
//           }
//         }, onError: (error) {
//           print('Stream error: $error');
//         }, cancelOnError: true);

//         // Store the subscription in the map
//         _streamSubscriptions[port] = subscription;
//       }).catchError((error) {
//         if (error is DioException) {
//           print(
//               'Failed to connect ${error.response?.statusCode}. Error: ${error.message}');
//         } else {
//           print('Unknown error while connecting to SSE for: $error');
//         }
//       });
//     }
//   }

//   // Disconnect from all SSE connections
//   void disconnectAll() {
//     _streamSubscriptions.forEach((port, subscription) {
//       subscription?.cancel(); // Cancel the subscription for each port
//       print('Disconnected from port $port');
//     });

//     // Clear the active subscriptions map
//     _streamSubscriptions.clear();
//     print('All SSE connections have been disconnected.');
//   }

//   // Disconnect from a specific port
//   void disconnectFromPort(int port) {
//     final subscription = _streamSubscriptions[port];
//     if (subscription != null) {
//       subscription.cancel(); // Cancel the specific stream subscription
//       _streamSubscriptions.remove(port); // Remove it from the map
//       print('Disconnected from port $port');
//     } else {
//       print('No active connection for port $port.');
//     }
//   }
// }
