import 'package:hive_flutter/hive_flutter.dart';

import '../../../commons/constants.dart';
import '../../../commons/extensions.dart';
import '../../../commons/utils.dart';
import '../models/balance_history.dart';
import '../models/betting_statistics.dart';
import '../models/fake_bet.dart';
import '../models/tip_model.dart';
import 'tips_repository.dart';

class FakeBetsRepository {
  final Box<FakeBet> box = Hive.box(Constants.fakeBetsBox);
  final Box<BettingStatistics> statsBox = Hive.box(Constants.bettingStatsBox);
  final Box<BalanceHistory> balanceHistoryBox = Hive.box(Constants.balanceHistoryBox);
  final String _bettingStatsKey = 'betting_stats';

  FakeBetsRepository() {
    if (statsBox.isEmpty) {
      final initialStats = BettingStatistics.initial();
      saveBettingStats(initialStats);
      saveBalanceHistory(amount: initialStats.balance, type: BalanceHistoryType.initial);
    }
  }

  Future saveBettingStats(BettingStatistics stats) async {
    await statsBox.put(_bettingStatsKey, stats);
  }

  BettingStatistics getBettingStats() {
    return statsBox.get(_bettingStatsKey) ?? BettingStatistics.initial();
  }

  Future saveBalanceHistory({required double amount, required BalanceHistoryType type}) async {
    final BalanceHistory balanceHistory = BalanceHistory.make(amount: amount, type: type);
    await balanceHistoryBox.put(balanceHistory.id, balanceHistory);
  }

  List<BalanceHistory> getAllBalanceHistory() {
    final List<BalanceHistory> balanceHistoryItems = balanceHistoryBox.values.toList();
    balanceHistoryItems.sort((a, b) => b.date.compareTo(a.date));
    return balanceHistoryItems;
  }

  Future addFakeBet(FakeBet fakeBet) async {
    await box.put(fakeBet.id, fakeBet);
  }

  List<FakeBet> getAllFakeBets() {
    final List<FakeBet> fakeBets = box.values.toList();
    fakeBets.sort((a, b) => b.date.compareTo(a.date));
    return fakeBets;
  }

  List<FakeBet> _getPendingFakeBets() {
    final List<FakeBet> pendingFakeBets =
    getAllFakeBets().where((fakeBet) => fakeBet.status == TipStatus.pending.status).toList();

    return pendingFakeBets;
  }

  List<String> _getPendingBetsIds(List<FakeBet> pendingFakeBets) {
    List<String> pendingBetsIds = [];
    for (final FakeBet fakeBet in pendingFakeBets) {
      pendingBetsIds
          .addAll(fakeBet.bets.where((bet) => bet.isReadyToUpdate()).map((bet) => bet.id).toList());
    }

    //remove duplicate entries
    pendingBetsIds = pendingBetsIds.toSet().toList();
    return pendingBetsIds;
  }

  Future<List<Tip>> _getTipsToUpdate(List<String> pendingBetsIds) async {
    List<Tip> tips = [];
    try {
      //Get updated tips
      tips = await TipsRepository().getTipsByIds(pendingBetsIds);
    } catch (e) {
      printMessage('Error getting tips');
    }
    return tips;
  }

  Future calculateBetsOutcome() async {
    final BettingStatistics bettingStats = getBettingStats();
    printMessage(bettingStats.toString(), tag: 'calculateBetsOutcome');
    final List<FakeBet> pendingFakeBets = _getPendingFakeBets();

    final List<String> pendingBetsIds = _getPendingBetsIds(pendingFakeBets);
    printMessage(pendingBetsIds.join(' | '), tag: 'calculateBetsOutcome');

    final List<Tip> tips = await _getTipsToUpdate(pendingBetsIds);
    if (tips.isEmpty) return;

    final List<Future> updatedFakeBetsFutures = [];
    for (final FakeBet fakeBet in pendingFakeBets) {
      printMessage(fakeBet.toString(), tag: 'calculateBetsOutcome');
      final List<Tip> bets = fakeBet.bets;
      // final List<Tip> bets = tips.where((tip) => fakeBet.bets.contains(tip)).toList();
      for (final bet in fakeBet.bets) {
        printMessage('Bet $bet', tag: 'calculateBetsOutcome');
        try {
          final tip = tips
              .where((tip) => bet.id == tip.id)
              .first;
          printMessage('Tip $tip', tag: 'calculateBetsOutcome');
          bets.removeWhere((bet) => bet.id == tip.id);
          bets.add(tip);
        } on StateError catch (_) {
          continue;
        }
      }

      String status = '';
      double returnAmount;

      if (bets
          .where((bet) => bet.status == TipStatus.pending.status)
          .isNotEmpty) {
        status = TipStatus.pending.status;
        returnAmount = fakeBet.returnAmount;
      } else if (bets
          .where((bet) => bet.status == TipStatus.lost.status)
          .isNotEmpty) {
        status = TipStatus.lost.status;
        returnAmount = -fakeBet.stake;
        bettingStats.lostBets++;
        bettingStats.pendingBets--;
      } else if (bets
          .where((bet) => bet.status == TipStatus.canceled.status)
          .isNotEmpty) {
        status = TipStatus.canceled.status;
        returnAmount = fakeBet.stake;
        bettingStats.balance += returnAmount;
        bettingStats.returnedBets++;
        bettingStats.pendingBets--;
        saveBalanceHistory(amount: returnAmount, type: BalanceHistoryType.betReturn);
      } else {
        status = TipStatus.won.status;
        returnAmount = fakeBet.stake * fakeBet.odds;
        bettingStats.balance += returnAmount;
        bettingStats.wonBets++;
        bettingStats.pendingBets--;
        saveBalanceHistory(amount: returnAmount, type: BalanceHistoryType.betWon);
      }
      printMessage('Status: $status - returnAmount: $returnAmount', tag: 'calculateBetsOutcome');

      final FakeBet updatedFakeBet = fakeBet.copyWith(
        bets: bets,
        status: status,
        returnAmount: returnAmount,
      );
      printMessage('updatedFakeBet: $updatedFakeBet', tag: 'calculateBetsOutcome');

      updatedFakeBetsFutures.add(addFakeBet(updatedFakeBet));
    }
    await Future.wait(updatedFakeBetsFutures);
    await saveBettingStats(bettingStats);
  }
}
