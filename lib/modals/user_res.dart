import 'dart:convert';

UserRes userResFromJson(String str) => UserRes.fromJson(json.decode(str));

String userResToJson(UserRes data) => json.encode(data.toJson());

class UserRes {
  String? userId;
  String? email;
  String? phone;
  final String? roleId;
  final int? emailOtp;
  final int? phoneOtp;
  String? username;
  final int? otp;
  final String? token;
  final String? type;
  bool notificationSeen;
  String? image;
  String? name;
  String? signUpSuccessful;
  String? yourAccountHasBeenCreated;
  String? referralCode;
  String? referralUrl;
  String? displayName;
  bool? signupStatus;
  // int? subscriptionPurchased;
  final UserMembershipRes? membership;
  final TradeRes? trade;
  int? affiliateStatus;
  String? phoneCode;
  dynamic pointEarn;
  num? selfRank;
  // final String? blackFridayMessage;
  final bool? showBlackFriday;
  final BlackFridayRes? blackFriday;
  UserRes({
    // this.blackFridayMessage,
    this.blackFriday,
    this.showBlackFriday,
    this.email,
    this.membership,
    this.phone,
    this.roleId,
    this.emailOtp,
    this.phoneOtp,
    this.otp,
    this.username,
    this.token,
    this.userId,
    this.type,
    this.notificationSeen = false,
    this.image,
    this.name,
    this.signUpSuccessful,
    this.yourAccountHasBeenCreated,
    this.referralCode,
    this.referralUrl,
    this.displayName,
    this.signupStatus = false,
    this.affiliateStatus,
    this.phoneCode,
    this.pointEarn,
    this.trade,
    this.selfRank,
  });

  factory UserRes.fromJson(Map<String, dynamic> json) => UserRes(
        // blackFridayMessage: json['black_friday_message'],
        showBlackFriday: json['black_friday_membership'],
        email: json["email"],
        blackFriday: json["black_friday"] == null
            ? null
            : BlackFridayRes.fromJson(json["black_friday"]),
        userId: json['_id'],
        phone: json["phone"],
        roleId: json["role_id"],
        emailOtp: json["email_otp"],
        phoneOtp: json["phone_otp"],
        // subscriptionPurchased: json["subscription_purchased"],
        username: json["username"],
        otp: json["otp"],
        membership: json["membership"] == null
            ? null
            : UserMembershipRes.fromJson(json["membership"]),
        token: json["token"],
        type: json["type"],
        image: json["image"],
        name: json["name"],
        signUpSuccessful: json["sign_up_successful"],
        yourAccountHasBeenCreated: json["your_account_has_been_created"],
        referralCode: json["referral_code"],
        referralUrl: json["referral_url"],
        displayName: json["display_name"],
        signupStatus: json["signupStatus"],
        affiliateStatus: json["affiliate_status"],
        phoneCode: json["phone_code"],
        pointEarn: json["point_earn"],
        trade: json["trade"] == null ? null : TradeRes.fromJson(json["trade"]),
        selfRank: json['self_rank'],
      );

  Map<String, dynamic> toJson() => {
        // 'black_friday_message': blackFridayMessage,
        'black_friday_membership': showBlackFriday,
        "email": email,
        "black_friday": blackFriday?.toJson(),

        "phone": phone,
        "_id": userId,
        "role_id": roleId,
        // "subscription_purchased": subscriptionPurchased,
        "email_otp": emailOtp,
        "phone_otp": phoneOtp,
        "username": username,
        "otp": otp,
        "token": token,
        "type": type,
        "image": image,
        "name": name,
        "sign_up_successful": signUpSuccessful,
        "your_account_has_been_created": yourAccountHasBeenCreated,
        "referral_code": referralCode,
        "referral_url": referralUrl,
        "display_name": displayName,
        "membership": membership?.toJson(),
        "signupStatus": signupStatus,
        "affiliate_status": affiliateStatus,
        "phone_code": phoneCode,
        "point_earn": pointEarn,
        "trade": trade?.toJson(),
        "self_rank": selfRank,
      };
}

class UserMembershipRes {
  int? purchased;
  final String? displayName;
  // final String? color;
  // final bool? canUpgrade;
  final List<MembershipPermissionRes>? permissions;
  final UpgradeMembershipTextRes? upgradeText;

  UserMembershipRes({
    this.purchased,
    this.displayName,
    // this.canUpgrade,
    // this.color,
    this.permissions,
    this.upgradeText,
  });

  factory UserMembershipRes.fromJson(Map<String, dynamic> json) =>
      UserMembershipRes(
        purchased: json["purchased"],
        // canUpgrade: json['can_upgrade'],
        displayName: json["display_name"],
        // color: json["color"],
        permissions: json["permissionsNew"] == null
            ? []
            : List<MembershipPermissionRes>.from(
                json["permissionsNew"]!
                    .map((x) => MembershipPermissionRes.fromJson(x)),
              ),
        upgradeText: json["upgrade_text"] == null
            ? null
            : UpgradeMembershipTextRes.fromJson(json["upgrade_text"]),
      );

  Map<String, dynamic> toJson() => {
        "purchased": purchased,
        "display_name": displayName,
        // "can_upgrade": canUpgrade,
        // "color": color,
        "permissionsNew": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x.toJson())),
        "upgrade_text": upgradeText?.toJson(),
      };
}

class MembershipPermissionRes {
  final String key;
  final int status;

  MembershipPermissionRes({
    required this.key,
    required this.status,
  });

  factory MembershipPermissionRes.fromJson(Map<String, dynamic> json) =>
      MembershipPermissionRes(
        key: json["key"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "status": status,
      };
}

class TradeRes {
  final num? amount;
  final num? paid;

  TradeRes({
    required this.amount,
    required this.paid,
  });

  factory TradeRes.fromJson(Map<String, dynamic> json) => TradeRes(
        amount: json["trade_amount"],
        paid: json['trade_paid'],
      );

  Map<String, dynamic> toJson() => {
        "trade_amount": amount,
        "trade_paid": paid,
      };
}

class UpgradeMembershipTextRes {
  final String? text;
  final String? button;

  UpgradeMembershipTextRes({this.text, this.button});

  factory UpgradeMembershipTextRes.fromJson(Map<String, dynamic> json) =>
      UpgradeMembershipTextRes(
        text: json["text"],
        button: json['button'],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "button": button,
      };
}

class BlackFridayRes {
  final String? title;
  final String? checkbox;
  final String? html;
  final String? yesBtn;
  final String? noBtn;

  BlackFridayRes({
    this.title,
    this.checkbox,
    this.html,
    this.yesBtn,
    this.noBtn,
  });

  factory BlackFridayRes.fromJson(Map<String, dynamic> json) => BlackFridayRes(
        title: json["title"],
        checkbox: json["checkbox"],
        html: json["html"],
        yesBtn: json["yes_btn"],
        noBtn: json["no_btn"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "checkbox": checkbox,
        "html": html,
        "yes_btn": yesBtn,
        "no_btn": noBtn,
      };
}
