import 'dart:convert';
import 'package:intl/intl.dart';

List<DateTime> holidayListResFromMap(String str) =>
    List<DateTime>.from(json.decode(str).map((x) => DateFormat('MM-dd-yyyy').parse(x)));

String holidayListResToMap(List<DateTime> data) =>
    json.encode(List<String>.from(data.map((x) => DateFormat('MM-dd-yyyy').format(x))));


HolidayRes holidayResFromMap(String str) => HolidayRes.fromMap(json.decode(str));

String holidayResToMap(HolidayRes data) => json.encode(data.toMap());

class HolidayRes {
  final List<DateTime>? holidays;

  HolidayRes({
    this.holidays,
  });

  /*factory HolidayRes.fromMap(Map<String, dynamic> json) => HolidayRes(

    holidays: json["data"] == null
        ? []
        : List<DateTime>.from(json["data"].map((x) => DateTime.parse(x))),

  );*/
  factory HolidayRes.fromMap(Map<String, dynamic> json) {
    final dateFormat = DateFormat('MM-dd-yyyy');
    return HolidayRes(
      holidays: json["data"] == null
          ? []
          : List<DateTime>.from(json["data"].map((x) => dateFormat.parse(x))),
    );
  }
  Map<String, dynamic> toMap() => {
    "data": holidays == null
        ? []
        : List<dynamic>.from(holidays!.map((x) => x.toIso8601String())),

    //"data": holidays == null ? [] : List<dynamic>.from(holidays!.map((x) => x)),
  };
}
