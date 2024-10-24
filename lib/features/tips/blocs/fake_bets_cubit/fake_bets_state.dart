part of 'fake_bets_cubit.dart';

sealed class FakeBetsState extends Equatable {
  const FakeBetsState();
  @override
  List<Object> get props => [];
}

final class FakeBetsInitial extends FakeBetsState {
  const FakeBetsInitial();
}

final class FakeBetsAdding extends FakeBetsState {
  const FakeBetsAdding();
}

final class FakeBetsAdded extends FakeBetsState {
  const FakeBetsAdded();
}

final class FakeBetsErrorAdding extends FakeBetsState {
  const FakeBetsErrorAdding();
}


