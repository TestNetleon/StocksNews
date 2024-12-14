// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class JwtGenerator {
//   static const String sdkAuthTokenEndpoint =
//       "https://us-central1-jwt-responder.cloudfunctions.net/getToken";

//   static Future<String?> create(String userId) async {
//     final body = {
//       'data': {
//         'user_id': userId,
//       }
//     };
//     var encodedBody = json.encode(body);
//     var header = {
//       "Content-Type": "application/json",
//       "Accept": "application/json"
//     };

//     try {
//       final response = await http.post(Uri.parse(sdkAuthTokenEndpoint),
//           body: encodedBody, headers: header);

//       // Log the response status and body
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         var responseJson = json.decode(response.body.toString());
//         var token = responseJson["data"]["token"];
//         print('$userId is using this token for SDK Auth: $token');
//         return token;
//       } else {
//         print('Failed to fetch JWT. Status code: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching JWT: $e');
//       return null;
//     }
//   }
// }
