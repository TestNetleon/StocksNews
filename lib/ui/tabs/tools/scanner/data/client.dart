import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SSEClient {
  final String url;
  StreamSubscription<String>? _subscription;

  // Private constructor
  SSEClient._internal(this.url);

  static SSEClient? _instance;

  factory SSEClient(String url) {
    if (_instance == null || _instance!.url != url) {
      _instance = SSEClient._internal(url);
    }
    return _instance!;
  }

  // Mark this method as async* for asynchronous streaming
  Stream<String> listen() async* {
    try {
      var request = http.Request('GET', Uri.parse(url));
      var response = await request.send();

      if (response.statusCode == 200) {
        await for (var line in response.stream
            .transform(utf8.decoder)
            .transform(LineSplitter())) {
          try {
            if (line.startsWith('data:')) {
              yield line.substring(5).trim(); // Yield the data after processing
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error processing line: $e');
            }
          }
        }
      } else {
        throw Exception(
            'Failed to connect to SSE server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error connecting to SSE server: $e');
      }
      rethrow;
    }
  }

  // Close method to stop the SSE stream and clean up
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    if (kDebugMode) {
      print('SSEClient connection closed.');
    }
  }
}
