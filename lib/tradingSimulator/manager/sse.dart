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
  final num? previousClose;
  final String symbol;

  StockDataManagerRes({
    this.price,
    this.change,
    this.changePercentage,
    this.type,
    this.previousClose,
    required this.symbol,
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
          previousClose: data['PreviousClose'],
          symbol: data['Identifier']);
    }
    return StockDataManagerRes(
      price: data['Last'],
      change: data['Change'],
      changePercentage: data['PercentChange'],
      previousClose: data['PreviousClose'],
      symbol: data['Identifier'],
    );
  }
}

// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
// import 'package:flutter_client_sse/flutter_client_sse.dart'; // Import the flutter_client_sse package
// import 'package:stocks_news_new/api/api_requester.dart';

// import '../../utils/constants.dart';

// class StockDataManagerRes {
//   final num? price;
//   final num? change;
//   final num? changePercentage;
//   final String? type;
//   final num? previousClose;

//   StockDataManagerRes({
//     this.price,
//     this.change,
//     this.changePercentage,
//     this.type,
//     this.previousClose,
//   });
// }

// class SSEManager {
//   static final SSEManager _instance = SSEManager._internal();
//   factory SSEManager() => _instance;

//   static SSEManager get instance => _instance;

//   final Map<String, Function(StockDataManagerRes)> _listeners = {};
//   final Map<String, StreamSubscription?> _subscriptions = {};

//   final Map<SimulatorEnum, Set<String>> _screenStreams = {};

//   SSEManager._internal();

//   void addListener(String symbol, Function(StockDataManagerRes) listener) {
//     _listeners[symbol] = listener;
//   }

//   void removeListener(String symbol) {
//     _listeners.remove(symbol);
//   }

//   void connectStock({required String symbol, required SimulatorEnum screen}) {
//     final url = 'https://dev.stocks.news:8021/symbolData?symbol=$symbol';

//     if (_screenStreams[screen]?.contains(symbol) == true) {
//       if (kDebugMode) {
//         print('Stream for $symbol is already connected.');
//         print('Url $url');
//       }
//       return;
//     }

//     _connectToStream(
//       url,
//       (data) {
//         final dataSymbol = data['Identifier'];
//         if (dataSymbol == symbol) {
//           _notifyListener(symbol, processStockData(data));
//         }
//       },
//       screen,
//     );

//     _screenStreams[screen] = (_screenStreams[screen] ?? {}).union({symbol});
//   }

//   void connectMultipleStocks(
//       {required List<String> symbols, required SimulatorEnum screen}) {
//     final currentStreams = _screenStreams[screen] ?? {};
//     final removedSymbols = currentStreams.difference(symbols.toSet());
//     for (var symbol in removedSymbols) {
//       disconnect(symbol);
//     }
//     print('current $currentStreams');
//     final newSymbols = symbols.toSet().difference(currentStreams);
//     print('new $newSymbols');
//     final url =
//         'https://dev.stocks.news:8021/symbolsData?symbol=${symbols.join(',')}';

//     if (newSymbols.isEmpty) {
//       if (kDebugMode) {
//         print('All streams for $screen are already connected.');
//         print('Url $url');
//       }
//       return;
//     }

//     _connectToStream(
//       url,
//       (data) {
//         final symbol = data['Identifier'];
//         if (symbol != null &&
//             _screenStreams[screen]?.contains(symbol) == true) {
//           _notifyListener(symbol, processStockData(data));
//         }
//       },
//       screen,
//     );

//     _screenStreams[screen] = currentStreams.union(newSymbols);
//   }

//   void disconnectScreen(SimulatorEnum screen) {
//     final symbols = _screenStreams[screen] ?? {};
//     for (var symbol in symbols) {
//       disconnect(symbol);
//       if (kDebugMode) {
//         print('Disconnected symbol $symbol for screen $screen');
//       }
//     }
//     _screenStreams.remove(screen);
//   }

//   void disconnectAllScreens() {
//     for (var screen in _screenStreams.keys.toList()) {
//       disconnectScreen(screen);
//     }
//     _listeners.clear();
//     if (kDebugMode) {
//       print('Disconnected all streams and cleared all resources.');
//     }
//   }

//   void _notifyListener(String symbol, StockDataManagerRes stockData) {
//     final listener = _listeners[symbol];
//     if (listener != null) {
//       listener(stockData);
//     }
//   }

//   void _connectToStream(
//     String url,
//     Function(Map<String, dynamic>) onData,
//     SimulatorEnum type,
//   ) {
//     if (kDebugMode) {
//       print('Trying to connect to $url');
//     }

//     final subscription = SSEClient.subscribeToSSE(
//             header: getHeaders(), method: SSERequestType.GET, url: url)
//         .listen(
//       (event) {
//         final rawData = event.data;
//         if (rawData == null) {
//           return;
//         }
//         if (rawData.startsWith('data:')) {
//           final jsonData = rawData.substring(5);
//           try {
//             final data = json.decode(jsonData) as Map<String, dynamic>;
//             onData(data);
//           } catch (e) {
//             if (kDebugMode) {
//               print('Error parsing SSE data: $e');
//             }
//           }
//         }
//       },
//       onError: (error) {
//         if (kDebugMode) {
//           print('Stream error: $error');
//         }
//         final uri = Uri.parse(url);
//         final symbols = uri.queryParameters['symbol']?.split(',');

//         if (symbols != null && symbols.isNotEmpty) {
//           for (var symbol in symbols) {
//             _handleStreamError(symbol);
//           }
//           _clearScreenData(type);
//         }
//       },
//       cancelOnError: false,
//     );

//     // Check if the URL is for a single symbol or multiple symbols
//     final uri = Uri.parse(url);
//     final symbols = uri.queryParameters['symbol']?.split(',');

//     if (symbols != null && symbols.length > 1) {
//       for (var symbol in symbols) {
//         _subscriptions[symbol] = subscription;
//       }
//     } else {
//       final symbol = uri.queryParameters['symbol'];
//       if (symbol != null) {
//         _subscriptions[symbol] = subscription;
//       }
//     }
//   }

//   // Clear data for a specific screen
//   void _clearScreenData(SimulatorEnum screen) {
//     final symbols = _screenStreams[screen] ?? {};
//     for (var symbol in symbols) {
//       disconnect(symbol);
//       removeListener(symbol);
//     }
//     _screenStreams.remove(screen);
//     if (kDebugMode) {
//       print('Cleared all data and disconnected streams for screen $screen');
//     }
//   }

//   void _handleStreamError(String symbol) {
//     disconnect(symbol);
//     removeListener(symbol);
//     if (kDebugMode) {
//       print('Cleared listener and subscription for $symbol due to an error.');
//     }
//   }

//   void disconnect(String symbol) {
//     final subscription = _subscriptions[symbol];
//     subscription?.cancel();
//     _subscriptions.remove(symbol);
//     if (kDebugMode) {
//       print('Disconnected SSE for $symbol');
//     }
//   }

//   StockDataManagerRes processStockData(Map<String, dynamic> data) {
//     final extendedHoursType = data['ExtendedHoursType'];
//     if (extendedHoursType == 'PreMarket' || extendedHoursType == 'PostMarket') {
//       return StockDataManagerRes(
//         price: data['ExtendedHoursPrice'],
//         change: data['ExtendedHoursChange'],
//         changePercentage: data['ExtendedHoursPercentChange'],
//         type: extendedHoursType,
//         previousClose: data['previousClose'],
//       );
//     }
//     return StockDataManagerRes(
//         price: data['Last'],
//         change: data['Change'],
//         changePercentage: data['PercentChange'],
//         previousClose: data['previousClose']);
//   }
// }
