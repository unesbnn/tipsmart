part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class UserChangedEvent extends AuthenticationEvent {

  const UserChangedEvent(this.user);
  final UserModel user;

  @override
  List<Object> get props => [user];
}