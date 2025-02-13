import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket;
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';

enum SocketEnum { home, newDetail, blogDetail, tickerDetail, tools }

SocketEnum? socketPage;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  static SocketService get instance => _instance;

  socket.Socket? _socket;

  /// Connect to the Socket.IO server
  void connect() {
    try {
      if (_socket != null && _socket!.connected) return;

      _socket = socket.io('https://dev.stocks.news:8098', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket?.onConnect((_) {
        if (kDebugMode) {
          print('Connected to----SOCKET');
        }
        emitUser();
        if (socketPage != null) {
          emitUpdateUser(socketPage ?? SocketEnum.home);
        }
      });
      _socket?.onDisconnect((_) {
        if (kDebugMode) {
          print('Disconnected from----SOCKET');
        }
        disconnect();
      });
      _socket?.onError((data) {
        if (kDebugMode) {
          print('Error----SOCKET : $data');
        }
      });

      _socket?.connect();
    } catch (e) {
      if (kDebugMode) {
        print('Catch----SOCKET : $e');
      }
    }
  }

  /// Emit an event to the server
  void emit(String event, dynamic data) {
    if (kDebugMode) {
      print('Emit----SOCKET: event $event, data: $data');
    }
    _socket?.emit(event, data);
  }

  /// Listen to an event from the server
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  /// Disconnect the socket
  void disconnect() {
    _socket?.disconnect();
  }

  void emitUser() async {
    String? fcmToken = await Preference.getFcmToken();
    try {
      UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;

      Map data = {'userToken': user?.token ?? ''};
      if (fcmToken != null && fcmToken != '') {
        data['fcmToken'] = fcmToken;
      }

      emit('isOnline', data);
    } catch (e) {
      if (kDebugMode) {
        print('Catch Emit----SOCKET : $e');
      }
      Map data = {'userToken': ''};
      if (fcmToken != null && fcmToken != '') {
        data['fcmToken'] = fcmToken;
      }
      emit('isOnline', data);
    }
  }

  void emitUpdateUser(SocketEnum type) async {
    socketPage = type;
    String? fcmToken = await Preference.getFcmToken();
    try {
      Map data = {'page': type.name};
      if (fcmToken != null && fcmToken != '') {
        data['fcmToken'] = fcmToken;
      }

      emit('updatePageCount', data);
    } catch (e) {
      if (kDebugMode) {
        print('Catch Emit----SOCKET : $e');
      }
      Map data = {'page': type.name};
      if (fcmToken != null && fcmToken != '') {
        data['fcmToken'] = fcmToken;
      }
      emit('updatePageCount', data);
    }
  }
}
