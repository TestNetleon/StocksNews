import 'dart:convert';

import 'package:stocks_news_new/models/my_home.dart';

OnboardingRes onboardingResFromJson(String str) =>
    OnboardingRes.fromJson(json.decode(str));

String onboardingResToJson(OnboardingRes data) => json.encode(data.toJson());

class OnboardingRes {
  final List<OnboardingListRes>? onboarding;
  final String? btnName;
  final HomeLoginBoxRes? loginBox;

  OnboardingRes({
    this.onboarding,
    this.btnName,
    this.loginBox,
  });

  factory OnboardingRes.fromJson(Map<String, dynamic> json) => OnboardingRes(
        onboarding: json["onboarding"] == null
            ? []
            : List<OnboardingListRes>.from(
                json["onboarding"]!.map((x) => OnboardingListRes.fromJson(x))),
        btnName: json["btn_name"],
        loginBox: json["login_box"] == null
            ? null
            : HomeLoginBoxRes.fromJson(json["login_box"]),
      );

  Map<String, dynamic> toJson() => {
        "onboarding": onboarding == null
            ? []
            : List<dynamic>.from(onboarding!.map((x) => x.toJson())),
        "btn_name": btnName,
        "login_box": loginBox?.toJson(),
      };
}

class OnboardingListRes {
  final String? title;
  final String? subTitle;
  final String? image;

  OnboardingListRes({
    this.title,
    this.subTitle,
    this.image,
  });

  factory OnboardingListRes.fromJson(Map<String, dynamic> json) =>
      OnboardingListRes(
        title: json["title"],
        subTitle: json["sub_title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "image": image,
      };
}
