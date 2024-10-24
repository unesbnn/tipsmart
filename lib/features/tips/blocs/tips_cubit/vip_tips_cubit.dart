import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../commons/utils.dart';
import '../../../services/api_service_error.dart';
import '../../models/tip_model.dart';
import '../../repositories/tips_repository.dart';
import '../api_state.dart';
import 'tips_state.dart';

class VipTipsCubit extends Cubit<ApiState> {
  final TipsRepository _repository;

  VipTipsCubit(this._repository) : super(const InitialState());

  Future getVipTips({
    String? date,
    int? betId,
    List<String>? ids,
  }) async {
    emit(const LoadingState());
    try {
      final List<Tip> tips;
      if (ids != null) {
        final List<Future<List<Tip>>> futures = [];
        final splitIds = splitList(ids);
        for (final ids in splitIds) {
          futures.add(_repository.getTips(ids: ids, vip: true));
        }

        tips = await _repository.getTipsByIds(ids, vip: true);
      } else {
        tips = await _repository.getTips(date: date, betId: betId, ids: ids, vip: true);
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
