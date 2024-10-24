part of 'authentication_bloc.dart';

enum AuthenticationStatus { guest, authenticated, unauthenticated }

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final UserModel user;
  // final bool firstSession;

  const AuthenticationState._({
    required this.status,
    this.user = UserModel.empty,
  });

  const AuthenticationState.unauthenticated()
      : this._(
          status: AuthenticationStatus.unauthenticated,
        );

  const AuthenticationState.authenticated(UserModel user)
      : this._(
          status: AuthenticationStatus.authenticated,
          user: user,
        );

  const AuthenticationState.guest()
      : this._(
          status: AuthenticationStatus.guest,
        );

  @override
  List<Object?> get props => [status, user];
}
