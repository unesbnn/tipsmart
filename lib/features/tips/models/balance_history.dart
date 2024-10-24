import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../commons/colors.dart';

part 'balance_history.g.dart';

@HiveType(typeId: 13)
class BalanceHistory {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final BalanceHistoryType type;

  BalanceHistory({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.type,
  });

  factory BalanceHistory.make({required double amount, required BalanceHistoryType type}) {
    return BalanceHistory(
      id: const Uuid().v4(),
      date: DateTime.now(),
      amount: amount,
      description: type.description,
      type: type,
    );
  }
}

@HiveType(typeId: 14)
enum BalanceHistoryType {
  @HiveField(0)
  initial('Initial Balance', AppColors.greenColor),
  @HiveField(1)
  topUp('Balance Top Up', AppColors.greenColor),
  @HiveField(2)
  betBought('Bet Bought', AppColors.redColor),
  @HiveField(3)
  betWon('Bet Won', AppColors.greenColor),
  @HiveField(4)
  betReturn('Bet Returned', AppColors.greenColor);

  final String description;
  final Color color;

  const BalanceHistoryType(this.description, this.color);
}