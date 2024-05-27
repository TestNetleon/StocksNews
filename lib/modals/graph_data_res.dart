import 'dart:convert';

import 'package:stocks_news_new/modals/home_alert_res.dart';

List<Chart> graphDataResFromJson(String str) => List<Chart>.from(
      json.decode(str).map((x) => Chart.fromJson(x)),
    );

String graphDataResToJson(List<Chart> data) => json.encode(
      List<dynamic>.from(data.map((x) => x.toJson())),
    );
