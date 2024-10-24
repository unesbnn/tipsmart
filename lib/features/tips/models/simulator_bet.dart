// import 'package:hive_flutter/hive_flutter.dart';
//
// import 'tip_model.dart';
//
// part 'simulator_bet.g.dart';
//
// @HiveType(typeId: 1)
// class SimulatorBet {
//   @HiveField(0)
//   final String id;
//   @HiveField(1)
//   final int fixtureId;
//   @HiveField(2)
//   final int fixtureTimestamp;
//   @HiveField(3)
//   final int leagueId;
//   @HiveField(4)
//   final String leagueName;
//   @HiveField(5)
//   final int homeTeamId;
//   @HiveField(6)
//   final String homeTeamName;
//   @HiveField(7)
//   final int awayTeamId;
//   @HiveField(8)
//   final String awayTeamName;
//   @HiveField(9)
//   final int betId;
//   @HiveField(10)
//   final String betName;
//   @HiveField(11)
//   final String betValueName;
//   @HiveField(12)
//   final double betValueOdd;
//
//   SimulatorBet({
//     required this.id,
//     required this.fixtureId,
//     required this.fixtureTimestamp,
//     required this.leagueId,
//     required this.leagueName,
//     required this.homeTeamId,
//     required this.homeTeamName,
//     required this.awayTeamId,
//     required this.awayTeamName,
//     required this.betId,
//     required this.betName,
//     required this.betValueName,
//     required this.betValueOdd,
//   });
//
//   factory SimulatorBet.fromTip(Tip tip) {
//     return SimulatorBet(
//       id: tip.id,
//       fixtureId: tip.fixtureId,
//       fixtureTimestamp: tip.fixtureTimestamp,
//       leagueId: tip.leagueId,
//       leagueName: tip.leagueName,
//       homeTeamId: tip.homeTeamId,
//       homeTeamName: tip.homeTeamName,
//       awayTeamId: tip.awayTeamId,
//       awayTeamName: tip.awayTeamName,
//       betId: tip.betId,
//       betName: tip.betName,
//       betValueName: tip.betValueName,
//       betValueOdd: tip.betValueOdd,
//     );
//   }
// }
