import 'package:dio/dio.dart';

import '../../../commons/utils.dart';
import '../../services/api_service_error.dart';
import '../../services/api_services.dart';
import '../models/tip_model.dart';
import '../models/tips_stats.dart';

class TipsRepository {
  Future<TipsStats> getTipsStats(String date) async {
    final String endpoint = '/getTipsStats?date=$date';

    try {
      final Response response = await ApiServices.getApiResponse(path: endpoint);

      final TipsStats stats = TipsStats.fromJson(response.data['stats']);

      return stats;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<Tip>> getTipsByIds(List<String> ids, {bool vip = false}) async {
    if(ids.isEmpty) return [];
    try {
      final List<Tip> tips;
      final List<Future<List<Tip>>> futures = [];
      final splitIds = splitList(ids);
      for (final ids in splitIds) {
        futures.add(getTips(ids: ids, vip: vip));
      }

      tips = (await Future.wait(futures)).expand((e) => e).toList();

      return tips;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Tip>> getTips({
    String? date,
    int? betId,
    List<String>? ids,
    bool vip = false,
  }) async {
    String endpoint = vip ? '/getVipTips?' : '/getTips?';
    if (date != null && betId != null) {
      endpoint += 'date=$date&betId=$betId';
    } else if (ids != null) {
      if (ids.length > 10) {
        throw const ApiServiceError('Max of 10 ids are allowed.');
      }
      endpoint += 'ids=${ids.join('-')}';
    } else {
      throw const ApiServiceError('Please specify date and betId or ids');
    }

    try {
      final Response response = await ApiServices.getApiResponse(path: endpoint);

      final List<Tip> tips = List<Tip>.from(response.data['tips'].map((x) => Tip.fromJson(x)));

      tips.sort((a, b) => a.fixtureTimestamp.compareTo(b.fixtureTimestamp));

      return tips;
    } catch (_) {
      rethrow;
    }
  }
}
