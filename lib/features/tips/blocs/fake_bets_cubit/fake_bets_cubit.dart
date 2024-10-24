import 'package:cron/cron.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../commons/extensions.dart';
import '../../../../commons/utils.dart';
import '../../models/balance_history.dart';
import '../../models/fake_bet.dart';
import '../../models/tip_model.dart';
import '../../repositories/fake_bets_repository.dart';

part 'fake_bets_state.dart';

class FakeBetsCubit extends Cubit<FakeBetsState> {
  final FakeBetsRepository _fakeBetsRepository;
  final cron = Cron();

  FakeBetsCubit(this._fakeBetsRepository) : super(const FakeBetsInitial()) {
    _fakeBetsRepository.calculateBetsOutcome();
    cron.schedule(Schedule.parse('*/15 * * * *'), _fakeBetsRepository.calculateBetsOutcome);
  }

  Future submitFakeBet(List<Tip> bets, double stake) async {
    emit(const FakeBetsAdding());
    final odds = calculateOdd(bets);
    final FakeBet fakeBet = FakeBet(
      id: const Uuid().v4(),
      uid: FirebaseAuth.instance.currentUser!.uid,
      bets: bets,
      odds: odds,
      stake: stake,
      date: DateTime.now(),
      status: TipStatus.pending.status,
      returnAmount: odds * stake,
    );

    try {
      await _fakeBetsRepository.addFakeBet(fakeBet);
      final betsStats =  _fakeBetsRepository.getBettingStats();
      betsStats.totalBets++;
      betsStats.pendingBets++;
      betsStats.balance -= stake;
      await _fakeBetsRepository.saveBettingStats(betsStats);
      await _fakeBetsRepository.saveBalanceHistory(amount: -stake, type: BalanceHistoryType.betBought);
      emit(const FakeBetsAdded());
    } catch (_) {
      emit(const FakeBetsErrorAdding());
    } finally {
      emit(const FakeBetsInitial());
    }
  }
}
