import 'dart:convert';

List<String> filterSectorsResFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String sectorsResToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
