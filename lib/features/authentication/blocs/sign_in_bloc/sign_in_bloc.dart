import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../services/app_exceptions.dart';
import '../../models/user_model.dart';
import '../../repositories/authentication_repository.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationRepository _authRepository;

  SignInBloc(this._authRepository) : super(SignInInitial()) {
    on<SignInWithEmailAndPasswordEvent>(_onSignIn);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignUpWithEmailAndPasswordEvent>(_onSignUp);
    on<SignInAnonymouslyEvent>(_onSignInAnonymously);
    on<SignOutEvent>(_onLogout);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  FutureOr<void> _onSignIn(SignInWithEmailAndPasswordEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await _authRepository.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      emit(SignInSuccess(_authRepository.currentUser));
    } on AppException catch (e) {
      emit(SignInError(e.message));
    }
  }

  FutureOr<void> _onSignInWithGoogle(SignInWithGoogleEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await _authRepository.signInWithGoogle();
      emit(SignInSuccess(_authRepository.currentUser));
    } on AppException catch (e) {
      emit(SignInError(e.message));
    }
  }

  FutureOr<void> _onSignUp(SignUpWithEmailAndPasswordEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await _authRepository.signUpWithEmailEndPassword(
          name: event.name, email: event.email, password: event.password);
      emit(SignInSuccess(_authRepository.currentUser));
    } on AppException catch (e) {
      emit(SignInError(e.message));
    }
  }

  FutureOr<void> _onSignInAnonymously(
      SignInAnonymouslyEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await _authRepository.signInAnonymously();
      emit(SignInSuccess(_authRepository.currentUser));
    } on AppException catch (e) {
      emit(SignInError(e.message));
    }
  }

  FutureOr<void> _onLogout(SignOutEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await _authRepository.signOut();
      emit(SignInSuccess(_authRepository.currentUser));
    } on AppException catch (e) {
      emit(SignInError(e.message));
    }
  }

  Future _onDeleteAccount(DeleteAccountEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      await _authRepository.deleteAccount();
      emit(SignInSuccess(_authRepository.currentUser));
    } on AppException catch (e) {
      emit(SignInError(e.message));
    }
  }
}
