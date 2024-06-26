import 'dart:convert';

FiltersData filtersFromJson(String str) =>
    FiltersData.fromJson(json.decode(str));

String filtersToJson(FiltersData data) => json.encode(data.toJson());

class FiltersData {
  final List<FiltersDataItem>? industries;
  final List<FiltersDataItem>? sectors;
  final List<FiltersDataItem>? exchange;
  final List<FiltersDataItem>? marketCap;
  final List<FiltersDataItem>? sorting;

  FiltersData({
    required this.industries,
    required this.sectors,
    required this.exchange,
    required this.marketCap,
    required this.sorting,
  });

  factory FiltersData.fromJson(Map<String, dynamic> json) => FiltersData(
        industries: json["industries"] == null
            ? null
            : List<FiltersDataItem>.from(
                json["industries"].map((x) => FiltersDataItem.fromJson(x))),
        sectors: json["sectors"] == null
            ? null
            : List<FiltersDataItem>.from(
                json["sectors"].map((x) => FiltersDataItem.fromJson(x))),
        exchange: json["exchange"] == null
            ? null
            : List<FiltersDataItem>.from(
                json["exchange"].map((x) => FiltersDataItem.fromJson(x))),
        marketCap: json["marketcap"] == null
            ? null
            : List<FiltersDataItem>.from(
                json["marketcap"].map((x) => FiltersDataItem.fromJson(x))),
        sorting: json["sorting"] == null
            ? null
            : List<FiltersDataItem>.from(
                json["sorting"].map((x) => FiltersDataItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "industries": industries == null
            ? null
            : List<dynamic>.from(industries!.map((x) => x.toJson())),
        "sectors": sectors == null
            ? null
            : List<dynamic>.from(sectors!.map((x) => x.toJson())),
        "exchange": exchange == null
            ? null
            : List<dynamic>.from(exchange!.map((x) => x.toJson())),
        "marketcap": marketCap == null
            ? null
            : List<dynamic>.from(marketCap!.map((x) => x.toJson())),
        "sorting": sorting == null
            ? null
            : List<dynamic>.from(sorting!.map((x) => x.toJson())),
      };
}

class FiltersDataItem {
  final String key;
  final String value;

  FiltersDataItem({
    required this.key,
    required this.value,
  });

  factory FiltersDataItem.fromJson(Map<String, dynamic> json) =>
      FiltersDataItem(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
