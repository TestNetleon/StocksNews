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
  final List<FiltersDataItem>? timePeriod;
  final List<FiltersDataItem>? breakOutType;
  final List<FiltersDataItem>? volumeType;
  final List<FiltersDataItem>? analystConsensus;
  final List<FiltersDataItem>? marketRank;

  FiltersData({
    required this.industries,
    required this.sectors,
    required this.exchange,
    required this.marketCap,
    required this.sorting,
    required this.timePeriod,
    this.breakOutType,
    this.volumeType,
    required this.analystConsensus,
    required this.marketRank,
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
        timePeriod: json["TimePeriod"] == null
            ? null
            : List<FiltersDataItem>.from(
                json["TimePeriod"].map((x) => FiltersDataItem.fromJson(x))),
        breakOutType: json["breakOutType"] == null
            ? null
            : List<FiltersDataItem>.from(
                json["breakOutType"].map((x) => FiltersDataItem.fromJson(x))),
        volumeType: json["volumeType"] == null
            ? null
            : List<FiltersDataItem>.from(
                json["volumeType"].map((x) => FiltersDataItem.fromJson(x))),
        analystConsensus: json["analystConsensus"] == null
            ? null
            : List<FiltersDataItem>.from(json["analystConsensus"]
                .map((x) => FiltersDataItem.fromJson(x))),
        marketRank: json["marketRank"] == null
            ? null
            : List<FiltersDataItem>.from(
                json["marketRank"].map((x) => FiltersDataItem.fromJson(x))),
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
        "TimePeriod": timePeriod == null
            ? null
            : List<dynamic>.from(timePeriod!.map((x) => x.toJson())),
        "breakOutType": breakOutType == null
            ? null
            : List<dynamic>.from(breakOutType!.map((x) => x.toJson())),
        "volumeType": volumeType == null
            ? null
            : List<dynamic>.from(volumeType!.map((x) => x.toJson())),
        "analystConsensus": analystConsensus == null
            ? null
            : List<dynamic>.from(analystConsensus!.map((x) => x.toJson())),
        "marketRank": marketRank == null
            ? null
            : List<dynamic>.from(marketRank!.map((x) => x.toJson())),
      };
}

class FiltersDataItem {
  final String? key;
  final String? value;

  FiltersDataItem({
    this.key,
    this.value,
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
