part of 'password_reset_cubit.dart';

abstract class PasswordResetState extends Equatable {
  const PasswordResetState();
  @override
  List<Object> get props => [];
}

class PasswordResetInitial extends PasswordResetState {
  const PasswordResetInitial();
}

class PasswordResetSending extends PasswordResetState {
  const PasswordResetSending();
}

class PasswordResetSent extends PasswordResetState {
  final int retryIn;
  const PasswordResetSent(this.retryIn);

  @override
  List<Object> get props => [retryIn];
}

class PasswordResetError extends PasswordResetState {
  const PasswordResetError();
}
