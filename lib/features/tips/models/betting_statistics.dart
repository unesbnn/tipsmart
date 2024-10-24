import 'package:hive_flutter/hive_flutter.dart';

import '../../../commons/constants.dart';

part 'betting_statistics.g.dart';

@HiveType(typeId: 12)
class BettingStatistics {
  @HiveField(0)
  double balance;
  @HiveField(1)
  int totalBets;
  @HiveField(2)
  int wonBets;
  @HiveField(3)
  int lostBets;
  @HiveField(4)
  int pendingBets;
  @HiveField(5)
  int returnedBets;

  BettingStatistics({
    required this.balance,
    required this.totalBets,
    required this.wonBets,
    required this.lostBets,
    required this.pendingBets,
    required this.returnedBets,
  });

  factory BettingStatistics.initial() {
    return BettingStatistics(
      balance: Constants.initialBalance,
      lostBets: 0,
      pendingBets: 0,
      returnedBets: 0,
      wonBets: 0,
      totalBets: 0,
    );
  }

  BettingStatistics copyWith({
    double? balance,
    int? totalBets,
    int? wonBets,
    int? lostBets,
    int? pendingBets,
    int? returnedBets,
  }) {
    return BettingStatistics(
      balance: balance ?? this.balance,
      totalBets: totalBets ?? this.totalBets,
      wonBets: wonBets ?? this.wonBets,
      lostBets: lostBets ?? this.lostBets,
      pendingBets: pendingBets ?? this.pendingBets,
      returnedBets: returnedBets ?? this.returnedBets,
    );
  }

  @override
  String toString() {
    return '$balance - TB: $totalBets - WB: $wonBets - LB: $lostBets - PB: $pendingBets - RB: $returnedBets';
  }
}
