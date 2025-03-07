import 'dart:convert';

LeaderBoardRes leaderBoardResFromJson(String str) =>
    LeaderBoardRes.fromJson(json.decode(str));

String leaderBoardResToJson(LeaderBoardRes data) => json.encode(data.toJson());

class LeaderBoardRes {
  final List<LeaderBoardData>? data;

  LeaderBoardRes({required this.data});

  factory LeaderBoardRes.fromJson(Map<String, dynamic> json) => LeaderBoardRes(
        data: json["data"] == null
            ? null
            : List<LeaderBoardData>.from(
                json["data"].map((x) => LeaderBoardData.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LeaderBoardData {
  final String? image;
  final String? imageType;
  final String? displayName;
  final dynamic rank;
  final dynamic points;

  LeaderBoardData({
    required this.image,
    required this.imageType,
    required this.displayName,
    required this.rank,
    required this.points,
  });

  factory LeaderBoardData.fromJson(Map<String, dynamic> json) =>
      LeaderBoardData(
        image: json["image"],
        imageType: json["image_type"],
        displayName: json["display_name"],
        rank: json["rank"],
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "image_type": imageType,
        "display_name": displayName,
        "rank": rank,
        "points": points,
      };
}
