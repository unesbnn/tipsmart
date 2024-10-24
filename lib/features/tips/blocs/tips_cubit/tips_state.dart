import '../../models/tip_model.dart';
import '../api_state.dart';

class TipsLoadedState extends ApiState {
  final List<Tip> tips;

  const TipsLoadedState({required this.tips});

  @override
  List<Object> get props => [tips];
}
