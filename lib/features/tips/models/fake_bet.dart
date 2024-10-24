import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'tip_model.dart';

part 'fake_bet.g.dart';

@HiveType(typeId: 11)
class FakeBet extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String uid;
  @HiveField(2)
  final List<Tip> bets;
  @HiveField(3)
  final double odds;
  @HiveField(4)
  final double stake;
  @HiveField(5)
  final DateTime date;
  @HiveField(6)
  final String status;
  @HiveField(7)
  final double returnAmount;

  const FakeBet({
    required this.id,
    required this.uid,
    required this.bets,
    required this.odds,
    required this.stake,
    required this.date,
    required this.status,
    required this.returnAmount,
  });

  FakeBet copyWith({
    List<Tip>? bets,
    String? status,
    double? returnAmount,
  }) {
    return FakeBet(
      id: id,
      uid: uid,
      bets: bets ?? this.bets,
      odds: odds,
      stake: stake,
      date: date,
      status: status ?? this.status,
      returnAmount: returnAmount ?? this.returnAmount,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'Odd: $odds - Stake: $stake - ${bets.length} bets';
  }
}
