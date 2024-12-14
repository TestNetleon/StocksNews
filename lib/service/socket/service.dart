// import 'package:socket_io_client/socket_io_client.dart' as io;

// import '../../utils/utils.dart';

// class SocketApi {
//   static final SocketApi _socketApi = SocketApi._internal();
//   io.Socket? socket;

//   SocketApi._internal();

//   factory SocketApi() {
//     return _socketApi;
//   }

//   void connectToServer() {
//     try {
//       socket = io.io(
//         'https://dev.stocks.news:8003',
//         <String, dynamic>{
//           'transports': ['websocket'],
//           'autoConnect': false,
//           'extraHeaders': {'Connection': 'keep-alive'},
//         },
//       );

//       socket?.connect();

//       socket?.onConnect((_) {
//         Utils().showLog('Connected to the server...');
//       });

//       socket?.onDisconnect((_) {
//         Utils().showLog('Disconnected from the server...');
//       });

//       socket?.onConnectError((data) {
//         Utils().showLog('Connection Error: $data');
//       });
//     } catch (e) {
//       Utils().showLog("Socket connection error: $e");
//     }
//   }

//   void gotEvent(String event, Function(dynamic) callback) {
//     socket?.on(event, (data) {
//       Utils().showLog('$data');

//       callback(data);
//     });
//   }

//   void disconnect() {
//     if (socket?.connected ?? false) {
//       socket?.disconnect();
//       Utils().showLog('Disconnected from the server');
//     } else {
//       Utils().showLog('Socket is not connected.');
//     }
//   }

//   bool isConnected() {
//     return socket?.connected ?? false;
//   }

//   void emitWithAck(String event, dynamic data, Function(dynamic) callback) {
//     if (socket?.connected ?? false) {
//       socket?.emitWithAck(event, data, ack: callback);
//       Utils().showLog('Event $event sent with acknowledgment: $data');
//     } else {
//       Utils().showLog('Socket is not connected. Cannot emit event $event.');
//     }
//   }
// }
