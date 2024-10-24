import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../commons/constants.dart';
import '../models/tip_model.dart';

class BetSlipRepository {
  final Box<Tip> box = Hive.box(Constants.simulatorBox);

  bool simulatorContainsBet(String betId) {
    return box.containsKey(betId);
  }

  Future addBetToSimulator(Tip bet) async {
    await box.put(bet.id, bet);
  }

  Future updateAllBets(List<Tip> bets) async {
    for(final bet in bets) {
      await addBetToSimulator(bet);
    }
  }

  Future deleteBetFromSimulator(String betId) async {
    await box.delete(betId);
  }

  bool switchS(Tip bet) {
    final bool isInSimulator = simulatorContainsBet(bet.id);
    isInSimulator  ? deleteBetFromSimulator(bet.id) : addBetToSimulator(bet);
    return !isInSimulator;
  }

  List<Tip> getAllBets() {
    final List<Tip> bets = box.values.toList();

    return bets;
  }

  Future<void> deleteAllBets() async {
    await box.clear();
  }
}
