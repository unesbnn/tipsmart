import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/authentication_repository.dart';

part 'password_reset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  final AuthenticationRepository _authRepository;
  PasswordResetCubit(this._authRepository) : super(const PasswordResetInitial());
  final int resendTime = 30;
  Future verifyUserEmail(String email) async {
    emit(const PasswordResetSending());
    try {
      await _authRepository.sendPasswordResetEmail(email);
      emit(PasswordResetSent(resendTime));
      Timer.periodic(const Duration(seconds: 1), (timer) {
        emit(PasswordResetSent(resendTime - timer.tick));
        if(timer.tick >= resendTime) {
          emit(const PasswordResetInitial());
          timer.cancel();
        }
      });
    } catch (e) {
      emit(const PasswordResetError());
    }
  }
}
