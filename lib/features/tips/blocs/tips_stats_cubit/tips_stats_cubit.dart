import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../commons/constants.dart';
import '../../../services/api_service_error.dart';
import '../../models/tips_stats.dart';
import '../../repositories/tips_repository.dart';
import '../api_state.dart';
import 'tips_stats_state.dart';

class TipsStatsCubit extends Cubit<ApiState> {
  final TipsRepository _repository;

  TipsStatsCubit(this._repository) : super(const InitialState());

  Future getTipsStats() async {
    emit(const LoadingState());
    final String today = DateFormat(Constants.apiDatePattern).format(DateTime.now());
    final String yesterday = DateFormat(Constants.apiDatePattern)
        .format(DateTime.now().subtract(const Duration(days: 1)));

    try {
      final results =
          await Future.wait([_repository.getTipsStats(today), _repository.getTipsStats(yesterday)]);

      final TipsStats todayStats = results[0];
      final TipsStats yesterdayStats = results[1];

      if (!isClosed) {
        emit(TipsStatsLoadedState(todayStats: todayStats, yesterdayStats: yesterdayStats));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}
