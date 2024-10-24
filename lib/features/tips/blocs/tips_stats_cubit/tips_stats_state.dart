import '../../models/tips_stats.dart';
import '../api_state.dart';

class TipsStatsLoadedState extends ApiState {
  final TipsStats todayStats;
  final TipsStats yesterdayStats;

  const TipsStatsLoadedState({required this.todayStats, required this.yesterdayStats});

  @override
  List<Object?> get props => [todayStats, yesterdayStats];
}