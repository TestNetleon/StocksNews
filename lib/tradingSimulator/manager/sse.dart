// import 'dart:convert';
// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import '../../utils/constants.dart';

// class SSEManager {
//   static final SSEManager _instance = SSEManager._internal();
//   factory SSEManager() => _instance;

//   static SSEManager get instance => _instance;

//   final Dio _dio = Dio();
//   final Map<String, Map<SimulatorEnum, Function(StockDataManagerRes)>>
//       _listeners = {};
//   final Map<String, Map<SimulatorEnum, StreamSubscription?>> _subscriptions =
//       {}; // Nested map
//   final Map<SimulatorEnum, Set<String>> _screenStreams = {};

//   SSEManager._internal();

//   // Add listener for a symbol on a specific screen
//   void addListener(String symbol, Function(StockDataManagerRes) listener,
//       SimulatorEnum screen) {
//     _listeners.putIfAbsent(symbol, () => {});
//     _listeners[symbol]![screen] = listener;
//   }

//   // Remove listener for a symbol on a specific screen
//   void removeListener(String symbol, SimulatorEnum screen) {
//     _listeners[symbol]?.remove(screen);
//     if (_listeners[symbol]?.isEmpty ?? true) {
//       _listeners.remove(symbol);
//     }
//   }

//   // Connect a stock stream to a specific screen
//   void connectStock({required String symbol, required SimulatorEnum screen}) {
//     final url = 'https://dev.stocks.news:8021/symbolData?symbol=$symbol';

//     if (_isStreamConnected(screen, symbol)) {
//       if (kDebugMode) {
//         print('Stream for $symbol is already connected.');
//       }
//       return;
//     }

//     _connectToStream(
//       url,
//       (data) {
//         final dataSymbol = data['Identifier'];
//         if (dataSymbol == symbol) {
//           _notifyListener(symbol, processStockData(data), screen);
//         }
//       },
//       screen,
//     );

//     _trackStreamForScreen(symbol, screen);
//   }

//   // Connect multiple stock streams to a specific screen
//   void connectMultipleStocks({
//     required List<String> symbols,
//     required SimulatorEnum screen,
//   }) {
//     try {
//       _screenStreams.putIfAbsent(screen, () => {});

//       final currentStreams = _screenStreams[screen]?.toSet() ?? {};
//       final removedSymbols = currentStreams.difference(symbols.toSet());

//       for (var symbol in removedSymbols) {
//         disconnect(symbol, screen);
//       }

//       print('current $currentStreams');
//       print('new ${symbols.toSet()}');
//       final newSymbols = symbols.toSet().difference(currentStreams);

//       if (newSymbols.isEmpty) {
//         if (kDebugMode) {
//           print('All streams for $screen are already connected.');
//         }
//         return;
//       }

//       final url =
//           'https://dev.stocks.news:8021/symbolsData?symbol=${symbols.join(',')}';

//       _connectToStream(
//         url,
//         (data) {
//           final symbol = data['Identifier'];

//           if (symbol != null) {
//             _screenStreams[screen]?.add(symbol);

//             bool symbolInStream =
//                 _screenStreams[screen]?.contains(symbol) ?? false;

//             if (symbolInStream) {
//               _notifyListener(symbol, processStockData(data), screen);
//             }
//           }
//         },
//         screen,
//       );

//       _trackStreamForScreen(symbols, screen);
//     } catch (e) {
//       print('ERROR $e');
//     }
//   }

//   // Disconnect all streams and listeners for a specific screen
//   // void disconnectScreen(SimulatorEnum screen) {
//   //   final symbols = _screenStreams[screen] ?? {};
//   //   for (var symbol in symbols) {
//   //     disconnect(symbol, screen);
//   //     removeListener(symbol, screen);
//   //   }
//   //   _screenStreams.remove(screen);
//   //   if (kDebugMode) {
//   //     print('Disconnected all streams and listeners for screen $screen');
//   //   }
//   // }
//   void disconnectScreen(SimulatorEnum screen) {
//     final symbols = _screenStreams[screen] ?? {};
//     for (var symbol in symbols) {
//       disconnect(symbol, screen);
//       removeListener(symbol, screen);
//     }
//     _screenStreams.remove(screen);
//     if (kDebugMode) {
//       print('Disconnected all streams and listeners for screen $screen');
//     }
//   }

//   // Disconnect all streams and listeners for all screens
//   void disconnectAllScreens() {
//     print('Before disconnect, active subscriptions: ${_subscriptions.length}');
//     _screenStreams.keys.toList().forEach(disconnectScreen);
//     _listeners.clear();
//     print('After disconnect, active subscriptions: ${_subscriptions.length}');
//     if (kDebugMode) {
//       print('Disconnected all streams and listeners for all screens.');
//     }
//   }

//   // Notify the listener for a stock on a specific screen
//   void _notifyListener(
//       String symbol, StockDataManagerRes stockData, SimulatorEnum screen) {
//     final listener = _listeners[symbol]?[screen];
//     if (listener != null) {
//       listener(stockData);
//     }
//   }

//   // Connect to a stock data stream
//   void _connectToStream(
//     String url,
//     Function(Map<String, dynamic>) onData,
//     SimulatorEnum screen,
//   ) {
//     if (kDebugMode) {
//       print('Trying to connect to $url');
//     }
//     _dio
//         .get<ResponseBody>(
//       url,
//       options: Options(responseType: ResponseType.stream),
//     )
//         .then((response) {
//       final subscription = response.data?.stream.listen(
//         (event) {
//           final rawData = String.fromCharCodes(event);
//           if (rawData.startsWith('data:')) {
//             final jsonData = rawData.substring(5);
//             try {
//               final data = json.decode(jsonData) as Map<String, dynamic>;
//               onData(data);
//             } catch (e) {
//               if (kDebugMode) {
//                 print('Error parsing SSE data: $e');
//               }
//             }
//           }
//         },
//         onError: (error) {
//           if (kDebugMode) {
//             print('Stream error: $error');
//           }
//           _handleStreamError(url, screen);
//         },
//         cancelOnError: false,
//       );

//       // Track subscription for single or multiple symbols
//       final symbols = Uri.parse(url).queryParameters['symbol']?.split(',');

//       if (symbols != null && symbols.length > 1) {
//         for (var symbol in symbols) {
//           _subscriptions.putIfAbsent(symbol, () => {});
//           _subscriptions[symbol]![screen] = subscription;
//         }
//       } else {
//         final symbol = symbols?.first;
//         if (symbol != null) {
//           _subscriptions.putIfAbsent(symbol, () => {});
//           _subscriptions[symbol]![screen] = subscription;
//         }
//       }
//     }).catchError((error) {
//       if (kDebugMode) {
//         print('Failed to connect to SSE: $error');
//       }
//       _handleStreamError(url, screen);
//     });
//   }

//   // Track streams for a specific screen
//   void _trackStreamForScreen(dynamic symbols, SimulatorEnum screen) {
//     final symbolsSet = symbols is String
//         ? {symbols}
//         : symbols is List<String>
//             ? symbols.toSet()
//             : <String>{};

//     _screenStreams[screen] = (_screenStreams[screen] ?? {}).union(symbolsSet);

//     print('Tracking streams for $screen: $_screenStreams[screen]');
//   }

//   // Check if the stream for the symbol is already connected
//   bool _isStreamConnected(SimulatorEnum screen, String symbol) {
//     return _screenStreams[screen]?.contains(symbol) == true;
//   }

//   // Handle stream errors by disconnecting the stream and clearing resources
//   void _handleStreamError(String url, SimulatorEnum screen) {
//     final symbols = Uri.parse(url).queryParameters['symbol']?.split(',');
//     if (symbols != null && symbols.isNotEmpty) {
//       for (var symbol in symbols) {
//         disconnect(symbol, screen);
//         removeListener(symbol, screen);
//       }
//     }
//     _clearScreenData(screen);
//   }

//   // Clear data for a specific screen
//   void _clearScreenData(SimulatorEnum screen) {
//     final symbols = _screenStreams[screen] ?? {};
//     for (var symbol in symbols) {
//       disconnect(symbol, screen);
//       removeListener(symbol, screen);
//     }
//     _screenStreams.remove(screen);
//     if (kDebugMode) {
//       print('Cleared all data and disconnected streams for screen $screen');
//     }
//   }

//   // Disconnect a symbol's stream for a specific screen
//   void disconnect(String symbol, SimulatorEnum screen) {
//     final subscription = _subscriptions[symbol]?[screen];
//     if (subscription != null) {
//       subscription.cancel();
//       print('Stream for $symbol on screen $screen is canceled.');
//     }
//     _subscriptions[symbol]?.remove(screen);
//     if (_subscriptions[symbol]?.isEmpty ?? true) {
//       _subscriptions.remove(symbol);
//       print('Removed $symbol from active subscriptions.');
//     }
//   }

//   // Process stock data and map it to the model
//   StockDataManagerRes processStockData(Map<String, dynamic> data) {
//     final extendedHoursType = streamKeysRes?.closeKeys?.type != null &&
//             streamKeysRes?.closeKeys?.type != ''
//         ? data[streamKeysRes?.closeKeys?.type]
//         : data['ExtendedHoursType'];
//     //
//     if (extendedHoursType == 'PreMarket' || extendedHoursType == 'PostMarket') {
//       return StockDataManagerRes(
//         //
//         price: streamKeysRes?.closeKeys?.price != null &&
//                 streamKeysRes?.closeKeys?.price != ''
//             ? data[streamKeysRes?.closeKeys?.price]
//             : data['ExtendedHoursPrice'],
//         //
//         change: streamKeysRes?.closeKeys?.change != null &&
//                 streamKeysRes?.closeKeys?.change != ''
//             ? data[streamKeysRes?.closeKeys?.change]
//             : data['ExtendedHoursChange'],
//         //
//         changePercentage: streamKeysRes?.closeKeys?.changePercentage != null &&
//                 streamKeysRes?.closeKeys?.changePercentage != ''
//             ? data[streamKeysRes?.closeKeys?.changePercentage]
//             : data['ExtendedHoursPercentChange'],
//         //
//         type: extendedHoursType,
//         previousClose: streamKeysRes?.closeKeys?.previousClose != null &&
//                 streamKeysRes?.closeKeys?.previousClose != ''
//             ? data[streamKeysRes?.closeKeys?.previousClose]
//             : data['Close'],
//         //
//         symbol: streamKeysRes?.closeKeys?.symbol != null &&
//                 streamKeysRes?.closeKeys?.symbol != ''
//             ? data[streamKeysRes?.closeKeys?.symbol]
//             : data['Identifier'],
//         //
//         time: streamKeysRes?.closeKeys?.time != null &&
//                 streamKeysRes?.closeKeys?.time != ''
//             ? data[streamKeysRes?.closeKeys?.time]
//             : data['ExtendedHoursTime'],
//         //
//       );
//     }
//     return StockDataManagerRes(
//       price: streamKeysRes?.liveKeys?.price != null &&
//               streamKeysRes?.liveKeys?.price != ''
//           ? data[streamKeysRes?.liveKeys?.price]
//           : data['Last'],
//       //
//       change: streamKeysRes?.liveKeys?.change != null &&
//               streamKeysRes?.liveKeys?.change != ''
//           ? data[streamKeysRes?.liveKeys?.change]
//           : data['Change'],
//       //
//       changePercentage: streamKeysRes?.liveKeys?.changePercentage != null &&
//               streamKeysRes?.liveKeys?.changePercentage != ''
//           ? data[streamKeysRes?.liveKeys?.changePercentage]
//           : data['PercentChange'],
//       //
//       previousClose: streamKeysRes?.liveKeys?.previousClose != null &&
//               streamKeysRes?.liveKeys?.previousClose != ''
//           ? data[streamKeysRes?.liveKeys?.previousClose]
//           : data['PreviousClose'],
//       //
//       symbol: streamKeysRes?.liveKeys?.symbol != null &&
//               streamKeysRes?.liveKeys?.symbol != ''
//           ? data[streamKeysRes?.liveKeys?.symbol]
//           : data['Identifier'],
//       //
//     );
//   }
// }

// class StockDataManagerRes {
//   final num? price;
//   final num? change;
//   final num? changePercentage;
//   final String? type;
//   final num? previousClose;
//   final String symbol;
//   final String? time;

//   StockDataManagerRes({
//     this.price,
//     this.change,
//     this.changePercentage,
//     this.type,
//     this.previousClose,
//     this.time,
//     required this.symbol,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'Price': price,
//       'Change': change,
//       'Change%': changePercentage,
//       'Type': type,
//       'Time': time,
//       'Previous Close': previousClose,
//       'Symbol': symbol,
//     };
//   }

//   @override
//   String toString() {
//     return toMap().toString();
//   }
// }

import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../utils/constants.dart';

class SSEManager {
  static final SSEManager _instance = SSEManager._internal();
  factory SSEManager() => _instance;

  static SSEManager get instance => _instance;

  final Dio _dio = Dio();
  final Map<String, Map<SimulatorEnum, Function(StockDataManagerRes)>>
      _listeners = {};
  final Map<String, Map<SimulatorEnum, StreamSubscription?>> _subscriptions =
      {}; // Nested map
  final Map<SimulatorEnum, Set<String>> _screenStreams = {};

  SSEManager._internal();

  // Add listener for a symbol on a specific screen
  void addListener(String symbol, Function(StockDataManagerRes) listener,
      SimulatorEnum screen) {
    _listeners.putIfAbsent(symbol, () => {});
    _listeners[symbol]![screen] = listener;
  }

  // Remove listener for a symbol on a specific screen
  void removeListener(String symbol, SimulatorEnum screen) {
    _listeners[symbol]?.remove(screen);
    if (_listeners[symbol]?.isEmpty ?? true) {
      _listeners.remove(symbol);
    }
  }

  // Connect a stock stream to a specific screen
  void connectStock({required String symbol, required SimulatorEnum screen}) {
    final url = 'https://dev.stocks.news:8052/symbolData?symbol=$symbol';

    if (_isStreamConnected(screen, symbol)) {
      if (kDebugMode) {
        print('Stream for $symbol is already connected on $screen.');
      }
      return; // Avoid reconnecting if already connected
    }

    _connectToStream(
      url,
      (data) {
        final dataSymbol = data['Identifier'];
        if (dataSymbol == symbol) {
          _notifyListener(symbol, processStockData(data), screen);
        }
      },
      screen,
    );

    _trackStreamForScreen(symbol, screen);
  }

  // Connect multiple stock streams to a specific screen
  void connectMultipleStocks({
    required List<String> symbols,
    required SimulatorEnum screen,
  }) {
    try {
      _screenStreams.putIfAbsent(screen, () => {});

      final currentStreams = _screenStreams[screen]?.toSet() ?? {};
      final removedSymbols = currentStreams.difference(symbols.toSet());
      if (kDebugMode) {
        print('removedSymbols $removedSymbols');
      }

      // Disconnect removed symbols
      for (var symbol in removedSymbols) {
        disconnect(symbol, screen);
      }

      if (kDebugMode) {
        print('current $currentStreams');
        print('new ${symbols.toSet()}');
      }

      final newSymbols = symbols.toSet().difference(currentStreams);

      if (newSymbols.isEmpty) {
        if (kDebugMode) {
          print('All streams for $screen are already connected.');
        }
        return;
      }

      final url =
          'https://dev.stocks.news:8052/symbolsData?symbol=${symbols.join(',')}';

      _connectToStream(
        url,
        (data) {
          final symbol = data['Identifier'];
          if (symbol != null) {
            _screenStreams[screen]?.add(symbol);

            bool symbolInStream =
                _screenStreams[screen]?.contains(symbol) ?? false;

            if (symbolInStream) {
              _notifyListener(symbol, processStockData(data), screen);
            }
          }
        },
        screen,
      );

      _trackStreamForScreen(symbols, screen);
    } catch (e) {
      if (kDebugMode) {
        print('ERROR $e');
      }
    }
  }

  void disconnectScreen(SimulatorEnum screen) {
    final symbols = _screenStreams[screen] ?? {};
    for (var symbol in symbols) {
      disconnect(symbol, screen);
      removeListener(symbol, screen);
    }
    _screenStreams.remove(screen);
    if (kDebugMode) {
      print('Disconnected all streams and listeners for screen $screen');
    }
  }

  // Disconnect all streams and listeners for all screens
  void disconnectAllScreens() {
    if (kDebugMode) {
      print(
          'Before disconnect, active subscriptions: ${_subscriptions.length}');
    }
    _screenStreams.keys.toList().forEach(disconnectScreen);
    _listeners.clear();
    if (kDebugMode) {
      print('After disconnect, active subscriptions: ${_subscriptions.length}');
    }
    if (kDebugMode) {
      print('Disconnected all streams and listeners for all screens.');
    }
  }

  // Notify the listener for a stock on a specific screen
  void _notifyListener(
      String symbol, StockDataManagerRes stockData, SimulatorEnum screen) {
    final listener = _listeners[symbol]?[screen];
    if (listener != null) {
      listener(stockData);
    }
  }

  // Connect to a stock data stream
  void _connectToStream(
    String url,
    Function(Map<String, dynamic>) onData,
    SimulatorEnum screen,
  ) {
    if (kDebugMode) {
      print('Trying to connect to $url');
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
          _handleStreamError(url, screen);
        },
        cancelOnError: true,
      );

      // Track subscription for single or multiple symbols
      final symbols = Uri.parse(url).queryParameters['symbol']?.split(',');

      if (symbols != null && symbols.length > 1) {
        for (var symbol in symbols) {
          _subscriptions.putIfAbsent(symbol, () => {});
          _subscriptions[symbol]![screen] = subscription;
        }
      } else {
        final symbol = symbols?.first;
        if (symbol != null) {
          _subscriptions.putIfAbsent(symbol, () => {});
          _subscriptions[symbol]![screen] = subscription;
        }
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to connect to SSE: $error');
      }
      _handleStreamError(url, screen);
    });
  }

  // Track streams for a specific screen
  void _trackStreamForScreen(dynamic symbols, SimulatorEnum screen) {
    final symbolsSet = symbols is String
        ? {symbols}
        : symbols is List<String>
            ? symbols.toSet()
            : <String>{};

    _screenStreams[screen] = (_screenStreams[screen] ?? {}).union(symbolsSet);

    if (kDebugMode) {
      print('Tracking streams for $screen: $_screenStreams[screen]');
    }
  }

  // Check if the stream for the symbol is already connected
  bool _isStreamConnected(SimulatorEnum screen, String symbol) {
    return _screenStreams[screen]?.contains(symbol) == true;
  }

  // Handle stream errors by disconnecting the stream and clearing resources
  void _handleStreamError(String url, SimulatorEnum screen) {
    final symbols = Uri.parse(url).queryParameters['symbol']?.split(',');
    if (symbols != null && symbols.isNotEmpty) {
      for (var symbol in symbols) {
        disconnect(symbol, screen);
        removeListener(symbol, screen);
      }
    }
    _clearScreenData(screen);
  }

  // Clear data for a specific screen
  void _clearScreenData(SimulatorEnum screen) {
    final symbols = _screenStreams[screen] ?? {};
    for (var symbol in symbols) {
      disconnect(symbol, screen);
      removeListener(symbol, screen);
    }
    _screenStreams.remove(screen);
    if (kDebugMode) {
      print('Cleared all data and disconnected streams for screen $screen');
    }
  }

  // Disconnect a symbol's stream for a specific screen
  void disconnect(String symbol, SimulatorEnum screen) {
    final subscription = _subscriptions[symbol]?[screen];
    if (subscription != null) {
      subscription.cancel();
      if (kDebugMode) {
        print('Stream for $symbol on screen $screen is canceled.');
      }
    }
    _subscriptions[symbol]?.remove(screen);
    if (_subscriptions[symbol]?.isEmpty ?? true) {
      _subscriptions.remove(symbol);
      if (kDebugMode) {
        print('Removed $symbol from active subscriptions.');
      }
    }
  }

  // Process stock data and map it to the model
  StockDataManagerRes processStockData(Map<String, dynamic> data) {
    final extendedHoursType = streamKeysRes?.closeKeys?.type != null &&
            streamKeysRes?.closeKeys?.type != ''
        ? data[streamKeysRes?.closeKeys?.type]
        : data['ExtendedHoursType'];
    //
    if (extendedHoursType == 'PreMarket' || extendedHoursType == 'PostMarket') {
      return StockDataManagerRes(
        //
        price: streamKeysRes?.closeKeys?.price != null &&
                streamKeysRes?.closeKeys?.price != ''
            ? data[streamKeysRes?.closeKeys?.price]
            : data['ExtendedHoursPrice'],
        //
        change: streamKeysRes?.closeKeys?.change != null &&
                streamKeysRes?.closeKeys?.change != ''
            ? data[streamKeysRes?.closeKeys?.change]
            : data['ExtendedHoursChange'],
        //
        changePercentage: streamKeysRes?.closeKeys?.changePercentage != null &&
                streamKeysRes?.closeKeys?.changePercentage != ''
            ? data[streamKeysRes?.closeKeys?.changePercentage]
            : data['ExtendedHoursPercentChange'],
        //
        type: extendedHoursType,
        previousClose: streamKeysRes?.closeKeys?.previousClose != null &&
                streamKeysRes?.closeKeys?.previousClose != ''
            ? data[streamKeysRes?.closeKeys?.previousClose]
            : data['Close'],
        //
        symbol: streamKeysRes?.closeKeys?.symbol != null &&
                streamKeysRes?.closeKeys?.symbol != ''
            ? data[streamKeysRes?.closeKeys?.symbol]
            : data['Identifier'],
        //
        time: streamKeysRes?.closeKeys?.time != null &&
                streamKeysRes?.closeKeys?.time != ''
            ? data[streamKeysRes?.closeKeys?.time]
            : data['ExtendedHoursTime'],
        //
      );
    }
    return StockDataManagerRes(
      price: streamKeysRes?.liveKeys?.price != null &&
              streamKeysRes?.liveKeys?.price != ''
          ? data[streamKeysRes?.liveKeys?.price]
          : data['Last'],
      //
      change: streamKeysRes?.liveKeys?.change != null &&
              streamKeysRes?.liveKeys?.change != ''
          ? data[streamKeysRes?.liveKeys?.change]
          : data['Change'],
      //
      changePercentage: streamKeysRes?.liveKeys?.changePercentage != null &&
              streamKeysRes?.liveKeys?.changePercentage != ''
          ? data[streamKeysRes?.liveKeys?.changePercentage]
          : data['PercentChange'],
      //
      previousClose: streamKeysRes?.liveKeys?.previousClose != null &&
              streamKeysRes?.liveKeys?.previousClose != ''
          ? data[streamKeysRes?.liveKeys?.previousClose]
          : data['PreviousClose'],
      //
      symbol: streamKeysRes?.liveKeys?.symbol != null &&
              streamKeysRes?.liveKeys?.symbol != ''
          ? data[streamKeysRes?.liveKeys?.symbol]
          : data['Identifier'],
      //
    );
  }
}

class StockDataManagerRes {
  final num? price;
  final num? change;
  final num? changePercentage;
  final String? type;
  final num? previousClose;
  final String symbol;
  final String? time;

  StockDataManagerRes({
    this.price,
    this.change,
    this.changePercentage,
    this.type,
    this.previousClose,
    this.time,
    required this.symbol,
  });

  Map<String, dynamic> toMap() {
    return {
      'Price': price,
      'Change': change,
      'Change%': changePercentage,
      'Type': type,
      'Time': time,
      'Previous Close': previousClose,
      'Symbol': symbol,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
