part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {

  const SignInSuccess(this.user);
  final UserModel user;

  @override
  List<Object> get props => [user];
}

class SignInError extends SignInState {

  const SignInError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
