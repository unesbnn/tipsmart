import 'package:equatable/equatable.dart';

abstract class ApiState extends Equatable {
  const ApiState();

  @override
  List<Object?> get props => [];
}

class InitialState extends ApiState {
  const InitialState();
}

class LoadingState extends ApiState {
  const LoadingState();
}

class ErrorState extends ApiState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
