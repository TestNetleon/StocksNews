// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class SSEClient {
//   final String url;

//   SSEClient(this.url);

//   Stream<String> listen() async* {
//     var request = http.Request('GET', Uri.parse(url));
//     var response = await request.send();

//     if (response.statusCode == 200) {
//       await for (var line in response.stream
//           .transform(utf8.decoder)
//           .transform(LineSplitter())) {
//         if (line.startsWith('data:')) {
//           yield line.substring(5).trim();
//         }
//       }
//     } else {
//       throw Exception('Failed to connect to SSE server');
//     }
//   }
// }
