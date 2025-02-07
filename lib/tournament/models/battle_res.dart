
import 'dart:convert';

BattleRes battleResFromMap(String str) => BattleRes.fromMap(json.decode(str));

String battleResToMap(BattleRes data) => json.encode(data.toMap());

class BattleRes {
  final bool? battle;

  BattleRes({
    this.battle,
  });

  factory BattleRes.fromMap(Map<String, dynamic> json) => BattleRes(
    battle: json["battle"],
  );

  Map<String, dynamic> toMap() => {
    "battle": battle,
  };
}
