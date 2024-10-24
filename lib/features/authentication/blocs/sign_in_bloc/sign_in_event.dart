part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignOutEvent extends SignInEvent {
  const SignOutEvent();
}

class DeleteAccountEvent extends SignInEvent {
  const DeleteAccountEvent();
}

class SignInWithGoogleEvent extends SignInEvent {
  const SignInWithGoogleEvent();
}

class SignInWithEmailAndPasswordEvent extends SignInEvent {

  const SignInWithEmailAndPasswordEvent({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignUpWithEmailAndPasswordEvent extends SignInEvent {

  const SignUpWithEmailAndPasswordEvent({required this.name, required this.email, required this.password});
  final String? name;
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignInAnonymouslyEvent extends SignInEvent {
  const SignInAnonymouslyEvent();
}