// MARK: PHASE 1

// import 'dart:convert';
// import 'dart:async';
// import 'package:dio/dio.dart';

// class SSEManager {
//   static final SSEManager _instance = SSEManager._internal();
//   factory SSEManager() => _instance;

//   static SSEManager get instance => _instance;

//   final Dio dio = Dio();
//   final Map<String, Function(StockDataManagerRes)> _listeners = {};
//   final Map<String, StreamSubscription?> _streamSubscriptions = {};

//   // Private constructor
//   SSEManager._internal();

//   // Add a listener for a specific symbol
//   void addListener(String symbol, Function(StockDataManagerRes) listener) {
//     _listeners[symbol] = listener;
//   }

//   // Remove listener for a specific symbol
//   void removeListener(String symbol) {
//     _listeners.remove(symbol);
//   }

//   // Connect to the SSE stream for a specific symbol
//   void connectToSSE(String symbol) {
//     const baseUrl = 'https://dev.stocks.news';
//     final url = '$baseUrl:8021/symbolData?symbol=$symbol';

//     print('Connecting to SSE for $symbol at $url');

//     dio
//         .get<ResponseBody>(
//       url,
//       options: Options(responseType: ResponseType.stream),
//     )
//         .then((response) {
//       final subscription = response.data?.stream.listen((event) {
//         final rawData = String.fromCharCodes(event);
//         print('Raw data for $symbol: $rawData');

//         // Check for valid JSON data
//         if (rawData.startsWith('data:')) {
//           final jsonData = rawData.substring(5); // Remove the 'data:' prefix

//           try {
//             final data = json.decode(jsonData);
//             // Process stock data
//             final stockData = processStockData(data);
//             // Notify listener with the processed stock data
//             _notifyListener(symbol, stockData);
//           } catch (e) {
//             print('Error parsing SSE data for $symbol: $e');
//           }
//         } else {
//           print('Received non-JSON data for $symbol: $rawData');
//         }
//       }, onError: (error) {
//         print('Stream error for $symbol: $error');
//       }, cancelOnError: true);

//       // Store the subscription for later use (for disconnecting)
//       _streamSubscriptions[symbol] = subscription;
//     }).catchError((error) {
//       print('Failed to connect to SSE for $symbol: $error');
//     });
//   }

//   void connectToSSEForMultipleStocks(List<String> symbols) {
//     const baseUrl = 'https://dev.stocks.news';

//     // Join symbols with commas to form the URL parameter
//     final symbolsParam = symbols.join(',');
//     final url = '$baseUrl:8021/symbolsData?symbol=$symbolsParam';

//     print('Connecting to SSE for multiple symbols: $symbolsParam at $url');

//     dio
//         .get<ResponseBody>(
//       url,
//       options: Options(responseType: ResponseType.stream),
//     )
//         .then((response) {
//       final subscription = response.data?.stream.listen((event) {
//         final rawData = String.fromCharCodes(event);
//         // print('Raw data for symbols: $rawData');

//         if (rawData.startsWith('data:')) {
//           final jsonData = rawData.substring(5);
//           try {
//             final data = json.decode(jsonData);
//             final symbol = data['Identifier'];
//             final stockData = processStockData(data);

//             // Notify listener for the specific symbol
//             _notifyListener(symbol, stockData);
//           } catch (e) {
//             print('Error parsing SSE data for symbols: $e');
//           }
//         } else {
//           print('Received non-JSON data for symbols: $rawData');
//         }
//       }, onError: (error) {
//         print('Stream error for symbols: $error');
//       }, cancelOnError: true);

//       for (var symbol in symbols) {
//         _streamSubscriptions[symbol] = subscription;
//       }
//     }).catchError((error) {
//       print('Failed to connect to SSE for multiple symbols: $error');
//     });
//   }

//   // Notify the listener with the processed stock data
//   void _notifyListener(String symbol, StockDataManagerRes stockData) {
//     if (_listeners.containsKey(symbol)) {
//       final listener = _listeners[symbol];
//       listener?.call(stockData); // Trigger the listener
//     }
//   }

//   // Process the raw stock data and decide if it's pre-market, post-market, or regular data
//   StockDataManagerRes processStockData(Map<String, dynamic> data) {
//     final extendedHoursType = data['ExtendedHoursType'];

//     // Check for pre-market or post-market data
//     if (extendedHoursType != null &&
//         (extendedHoursType == 'PreMarket' ||
//             extendedHoursType == 'PostMarket')) {
//       return StockDataManagerRes(
//         price: data['ExtendedHoursPrice'],
//         change: data['ExtendedHoursChange'],
//         changePercentage: data['ExtendedHoursPercentChange'],
//       );
//     } else {
//       // Regular market data
//       return StockDataManagerRes(
//         price: data['Last'],
//         change: data['Change'],
//         changePercentage: data['PercentChange'],
//       );
//     }
//   }

//   void disconnect(String symbol) {
//     final subscription = _streamSubscriptions[symbol];
//     if (subscription != null) {
//       subscription.cancel();
//       _streamSubscriptions.remove(symbol);
//       print('Disconnected from SSE for $symbol');
//     } else {
//       print('No active SSE connection for $symbol');
//     }
//   }

//   void disconnectAll() {
//     _streamSubscriptions.forEach((symbol, subscription) {
//       subscription?.cancel();
//       print('Disconnected from SSE for $symbol');
//     });

//     _streamSubscriptions.clear();
//     print('All SSE connections have been disconnected.');
//   }
// }

// // Stock data response model
// class StockDataManagerRes {
//   num? price;
//   final num? change;
//   final num? changePercentage;
//   final String? type;

//   StockDataManagerRes({
//     this.price,
//     this.change,
//     this.changePercentage,
//     this.type,
//   });

//   // Factory method to create StockDataManagerRes from raw data (useful for serialization)
//   factory StockDataManagerRes.fromJson(Map<String, dynamic> json) {
//     final extendedHoursType = json['ExtendedHoursType'];

//     if (extendedHoursType != null &&
//         (extendedHoursType == 'PreMarket' ||
//             extendedHoursType == 'PostMarket')) {
//       return StockDataManagerRes(
//         price: json['ExtendedHoursPrice'],
//         change: json['ExtendedHoursChange'],
//         changePercentage: json['ExtendedHoursPercentChange'],
//         type: extendedHoursType,
//       );
//     } else {
//       return StockDataManagerRes(
//         price: json['Last'],
//         change: json['Change'],
//         changePercentage: json['PercentChange'],
//       );
//     }
//   }
// }

// MARK: PHASE 2

// import 'dart:convert';
// import 'dart:async';
// import 'package:dio/dio.dart';

// class SSEManager {
//   static final SSEManager _instance = SSEManager._internal();
//   factory SSEManager() => _instance;

//   static SSEManager get instance => _instance;

//   final Dio _dio = Dio();
//   final Map<String, Function(StockDataManagerRes)> _listeners = {};
//   final Map<String, StreamSubscription?> _subscriptions = {};

//   SSEManager._internal();

//   /// Add a listener for a specific symbol
//   void addListener(String symbol, Function(StockDataManagerRes) listener) {
//     _listeners[symbol] = listener;
//   }

//   /// Remove listener for a specific symbol
//   void removeListener(String symbol) {
//     _listeners.remove(symbol);
//   }

//   /// Connect to the SSE stream for a specific symbol
//   void connectToSSE(String symbol) {
//     final url = 'https://dev.stocks.news:8021/symbolData?symbol=$symbol';

//     if (_subscriptions.containsKey(symbol)) {
//       print('Already connected to SSE for $symbol');
//       return;
//     }

//     _connectToStream(
//         url, (data) => _notifyListener(symbol, processStockData(data)));
//   }

//   /// Connect to SSE for multiple symbols
//   void connectToSSEForMultipleStocks(List<String> symbols) {
//     final symbolsParam = symbols.join(',');
//     final url = 'https://dev.stocks.news:8021/symbolsData?symbol=$symbolsParam';

//     for (var symbol in symbols) {
//       if (_subscriptions.containsKey(symbol)) {
//         print('Already connected to SSE for $symbol');
//         continue;
//       }
//     }

//     _connectToStream(url, (data) {
//       final symbol = data['Identifier'];
//       if (symbol != null) {
//         _notifyListener(symbol, processStockData(data));
//       }
//     });
//   }

//   /// Disconnect SSE for a specific symbol
//   void disconnect(String symbol) {
//     final subscription = _subscriptions[symbol];
//     subscription?.cancel();
//     _subscriptions.remove(symbol);
//     print('Disconnected from SSE for $symbol');
//   }

//   /// Disconnect all active SSE connections
//   void disconnectAll() {
//     for (var symbol in _subscriptions.keys) {
//       _subscriptions[symbol]?.cancel();
//     }
//     _subscriptions.clear();
//     print('All SSE connections have been disconnected.');
//   }

//   /// Notify the listener with processed stock data
//   void _notifyListener(String symbol, StockDataManagerRes stockData) {
//     final listener = _listeners[symbol];
//     if (listener != null) {
//       listener(stockData);
//     }
//   }

//   /// Connect to a generic SSE stream
//   void _connectToStream(String url, Function(Map<String, dynamic>) onData) {
//     _dio
//         .get<ResponseBody>(
//       url,
//       options: Options(responseType: ResponseType.stream),
//     )
//         .then((response) {
//       final subscription = response.data?.stream.listen((event) {
//         final rawData = String.fromCharCodes(event);
//         if (rawData.startsWith('data:')) {
//           final jsonData = rawData.substring(5); // Remove 'data:' prefix
//           try {
//             final data = json.decode(jsonData) as Map<String, dynamic>;
//             onData(data);
//           } catch (e) {
//             print('Error parsing SSE data: $e');
//           }
//         }
//       }, onError: (error) {
//         print('Stream error: $error');
//       }, cancelOnError: true);

//       if (url.contains('?symbol=')) {
//         // Single symbol
//         final symbol = Uri.parse(url).queryParameters['symbol'];
//         if (symbol != null) {
//           _subscriptions[symbol] = subscription;
//         }
//       } else {
//         // Multi-symbol
//         final symbols =
//             Uri.parse(url).queryParameters['symbol']?.split(',') ?? [];
//         for (var symbol in symbols) {
//           _subscriptions[symbol] = subscription;
//         }
//       }
//     }).catchError((error) {
//       print('Failed to connect to SSE: $error');
//     });
//   }

//   /// Process raw stock data into a usable format
//   StockDataManagerRes processStockData(Map<String, dynamic> data) {
//     final extendedHoursType = data['ExtendedHoursType'];
//     if (extendedHoursType == 'PreMarket' || extendedHoursType == 'PostMarket') {
//       return StockDataManagerRes(
//         price: data['ExtendedHoursPrice'],
//         change: data['ExtendedHoursChange'],
//         changePercentage: data['ExtendedHoursPercentChange'],
//         type: extendedHoursType,
//       );
//     }
//     return StockDataManagerRes(
//       price: data['Last'],
//       change: data['Change'],
//       changePercentage: data['PercentChange'],
//     );
//   }
// }

// class StockDataManagerRes {
//   final num? price;
//   final num? change;
//   final num? changePercentage;
//   final String? type;

//   StockDataManagerRes({
//     this.price,
//     this.change,
//     this.changePercentage,
//     this.type,
//   });

//   factory StockDataManagerRes.fromJson(Map<String, dynamic> json) {
//     return StockDataManagerRes(
//       price: json['Last'] ?? json['ExtendedHoursPrice'],
//       change: json['Change'] ?? json['ExtendedHoursChange'],
//       changePercentage:
//           json['PercentChange'] ?? json['ExtendedHoursPercentChange'],
//       type: json['ExtendedHoursType'],
//     );
//   }
// }

// MARK: PHASE 3

import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../utils/constants.dart';

class StockDataManagerRes {
  final num? price;
  final num? change;
  final num? changePercentage;
  final String? type;

  StockDataManagerRes({
    this.price,
    this.change,
    this.changePercentage,
    this.type,
  });
}

class SSEManager {
  static final SSEManager _instance = SSEManager._internal();
  factory SSEManager() => _instance;

  static SSEManager get instance => _instance;

  final Dio _dio = Dio();
  final Map<String, Function(StockDataManagerRes)> _listeners = {};
  final Map<String, StreamSubscription?> _subscriptions = {};

  final Map<SimulatorEnum, Set<String>> _screenStreams = {};

  SSEManager._internal();

  void addListener(String symbol, Function(StockDataManagerRes) listener) {
    _listeners[symbol] = listener;
  }

  void removeListener(String symbol) {
    _listeners.remove(symbol);
  }

  void connectStock({required String symbol, required SimulatorEnum screen}) {
    final url = 'https://dev.stocks.news:8021/symbolData?symbol=$symbol';

    if (_screenStreams[screen]?.contains(symbol) == true) {
      if (kDebugMode) {
        print('Stream for $symbol is already connected.');
        print('Url $url');
      }
      return;
    }

    _connectToStream(
      url,
      (data) {
        final dataSymbol = data['Identifier'];
        if (dataSymbol == symbol) {
          _notifyListener(symbol, processStockData(data));
        }
      },
      screen,
    );

    _screenStreams[screen] = (_screenStreams[screen] ?? {}).union({symbol});
  }

  void connectMultipleStocks(
      {required List<String> symbols, required SimulatorEnum screen}) {
    final currentStreams = _screenStreams[screen] ?? {};
    final removedSymbols = currentStreams.difference(symbols.toSet());
    for (var symbol in removedSymbols) {
      disconnect(symbol);
    }
    print('current $currentStreams');
    final newSymbols = symbols.toSet().difference(currentStreams);
    print('new $newSymbols');
    final url =
        'https://dev.stocks.news:8021/symbolsData?symbol=${symbols.join(',')}';

    if (newSymbols.isEmpty) {
      if (kDebugMode) {
        print('All streams for $screen are already connected.');
        print('Url $url');
      }
      return;
    }

    _connectToStream(
      url,
      (data) {
        final symbol = data['Identifier'];
        if (symbol != null &&
            _screenStreams[screen]?.contains(symbol) == true) {
          _notifyListener(symbol, processStockData(data));
        }
      },
      screen,
    );

    _screenStreams[screen] = currentStreams.union(newSymbols);
  }

  void disconnectScreen(SimulatorEnum screen) {
    final symbols = _screenStreams[screen] ?? {};
    for (var symbol in symbols) {
      disconnect(symbol);
      if (kDebugMode) {
        print('Disconnected symbol $symbol for screen $screen');
      }
    }
    _screenStreams.remove(screen);
  }

  void disconnectAllScreens() {
    for (var screen in _screenStreams.keys.toList()) {
      disconnectScreen(screen);
    }
    _listeners.clear();
    if (kDebugMode) {
      print('Disconnected all streams and cleared all resources.');
    }
  }

  void _notifyListener(String symbol, StockDataManagerRes stockData) {
    final listener = _listeners[symbol];
    if (listener != null) {
      listener(stockData);
    }
  }

  void _connectToStream(
    String url,
    Function(Map<String, dynamic>) onData,
    SimulatorEnum type,
  ) {
    if (kDebugMode) {
      print('Tyring to connect to $url');
    }
    _dio
        .get<ResponseBody>(
      url,
      options: Options(responseType: ResponseType.stream),
    )
        .then((response) {
      final subscription = response.data?.stream.listen(
        (event) {
          final rawData = String.fromCharCodes(event);
          if (rawData.startsWith('data:')) {
            final jsonData = rawData.substring(5);
            try {
              final data = json.decode(jsonData) as Map<String, dynamic>;
              onData(data);
            } catch (e) {
              if (kDebugMode) {
                print('Error parsing SSE data: $e');
              }
            }
          }
        },
        onError: (error) {
          if (kDebugMode) {
            print('Stream error: $error');
          }
          final uri = Uri.parse(url);
          final symbols = uri.queryParameters['symbol']?.split(',');

          if (symbols != null && symbols.isNotEmpty) {
            for (var symbol in symbols) {
              _handleStreamError(symbol);
            }
            _clearScreenData(type);
          }
        },
        cancelOnError: false,
      );

      // Check if the URL is for a single symbol or multiple symbols
      final uri = Uri.parse(url);
      final symbols = uri.queryParameters['symbol']?.split(',');

      if (symbols != null && symbols.length > 1) {
        for (var symbol in symbols) {
          _subscriptions[symbol] = subscription;
        }
      } else {
        final symbol = uri.queryParameters['symbol'];
        if (symbol != null) {
          _subscriptions[symbol] = subscription;
        }
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to connect to SSE: $error');
      }
    });
  }

// Clear data for a specific screen
  void _clearScreenData(SimulatorEnum screen) {
    final symbols = _screenStreams[screen] ?? {};
    for (var symbol in symbols) {
      disconnect(symbol);
      removeListener(symbol);
    }
    _screenStreams.remove(screen);
    if (kDebugMode) {
      print('Cleared all data and disconnected streams for screen $screen');
    }
  }

  void _handleStreamError(String symbol) {
    disconnect(symbol);
    removeListener(symbol);
    if (kDebugMode) {
      print('Cleared listener and subscription for $symbol due to an error.');
    }
  }

  void disconnect(String symbol) {
    final subscription = _subscriptions[symbol];
    subscription?.cancel();
    _subscriptions.remove(symbol);
    if (kDebugMode) {
      print('Disconnected SSE for $symbol');
    }
  }

  StockDataManagerRes processStockData(Map<String, dynamic> data) {
    final extendedHoursType = data['ExtendedHoursType'];
    if (extendedHoursType == 'PreMarket' || extendedHoursType == 'PostMarket') {
      return StockDataManagerRes(
        price: data['ExtendedHoursPrice'],
        change: data['ExtendedHoursChange'],
        changePercentage: data['ExtendedHoursPercentChange'],
        type: extendedHoursType,
      );
    }
    return StockDataManagerRes(
      price: data['Last'],
      change: data['Change'],
      changePercentage: data['PercentChange'],
    );
  }
}
