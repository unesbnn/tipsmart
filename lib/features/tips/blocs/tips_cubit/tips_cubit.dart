import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service_error.dart';
import '../../models/tip_model.dart';
import '../../repositories/tips_repository.dart';
import '../api_state.dart';
import 'tips_state.dart';

class TipsCubit extends Cubit<ApiState> {
  final TipsRepository _repository;

  TipsCubit(this._repository) : super(const InitialState());

  Future getTips({
    String? date,
    int? betId,
    List<String>? ids,
  }) async {
    emit(const LoadingState());
    try {
      final List<Tip> tips;
      if (ids != null) {
        // final List<Future<List<Tip>>> futures = [];
        // final splitIds = splitList(ids);
        // for (final ids in splitIds) {
        //   futures.add(_repository.getTips(ids: ids));
        // }

        tips = await _repository.getTipsByIds(ids);
      } else {
        tips = await _repository.getTips(date: date, betId: betId, ids: ids);
      }
      if (!isClosed) {
        emit(TipsLoadedState(tips: tips));
      }
    } on ApiServiceError catch (e) {
      if (!isClosed) {
        emit(ErrorState(message: e.message));
      }
    }
  }
}
