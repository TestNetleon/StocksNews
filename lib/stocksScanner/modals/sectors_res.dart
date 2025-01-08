import 'dart:convert';

List<String> sectorsResFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String sectorsResToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
