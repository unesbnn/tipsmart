import 'package:hive_flutter/hive_flutter.dart';

import '../../../commons/extensions.dart';

part 'tip_model.g.dart';

@HiveType(typeId: 10)
class Tip {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int fixtureId;
  @HiveField(2)
  final int fixtureTimestamp;
  @HiveField(3)
  final String fixtureDate;
  @HiveField(4)
  final String fixtureStatus;
  @HiveField(5)
  final String createDate;
  @HiveField(6)
  final int leagueId;
  @HiveField(7)
  final String leagueName;
  @HiveField(8)
  final int homeTeamId;
  @HiveField(9)
  final String homeTeamName;
  @HiveField(10)
  final int awayTeamId;
  @HiveField(11)
  final String awayTeamName;
  @HiveField(12)
  final int betId;
  @HiveField(13)
  final String betName;
  @HiveField(14)
  final String betValueName;
  @HiveField(15)
  final double betValueOdd;
  @HiveField(16)
  final String? halftimeScore;
  @HiveField(17)
  final String? fullTimeScore;
  @HiveField(18)
  final String? extraTimeScore;
  @HiveField(19)
  final String? penaltyScore;
  @HiveField(20)
  final String status;

  Tip({
    required this.id,
    required this.fixtureId,
    required this.fixtureTimestamp,
    required this.fixtureDate,
    required this.fixtureStatus,
    required this.createDate,
    required this.leagueId,
    required this.leagueName,
    required this.homeTeamId,
    required this.homeTeamName,
    required this.awayTeamId,
    required this.awayTeamName,
    required this.betId,
    required this.betName,
    required this.betValueName,
    required this.betValueOdd,
    required this.halftimeScore,
    required this.fullTimeScore,
    required this.extraTimeScore,
    required this.penaltyScore,
    required this.status,
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'],
      fixtureId: json['fixtureId'],
      fixtureTimestamp: json['fixtureTimestamp'],
      fixtureDate: json['fixtureDate'],
      fixtureStatus: json['fixtureStatus'],
      createDate: json['createDate'],
      leagueId: json['leagueId'],
      leagueName: json['leagueName'],
      homeTeamId: json['homeTeamId'],
      homeTeamName: json['homeTeamName'],
      awayTeamId: json['awayTeamId'],
      awayTeamName: json['awayTeamName'],
      betId: json['betId'],
      betName: json['betName'],
      betValueName: json['betValueName'],
      betValueOdd:
          json['betValueOdd'] is num ? json['betValueOdd'] : double.parse(json['betValueOdd']),
      halftimeScore: json['halftimeScore'],
      fullTimeScore: json['fullTimeScore'],
      extraTimeScore: json['extraTimeScore'],
      penaltyScore: json['penaltyScore'],
      status: json['status'],
    );
  }

  bool canAddToSimulator() {
    return status == TipStatus.pending.status &&
        fixtureTimestamp > DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  bool isReadyToUpdate() {
    return status == TipStatus.pending.status &&
        DateTime.now().millisecondsSinceEpoch ~/ 1000 > fixtureTimestamp + 2 * 60 * 60;
  }

  @override
  String toString() {
    return '$id - $betValueName - $status - $homeTeamName vs $awayTeamName';
  }
}
