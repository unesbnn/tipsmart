import '../../commons/errors_strings.dart';

class AppException implements Exception{
  final String message;
  const AppException([this.message = ErrorsStrings.unknownError]);

  factory AppException.signInFailure(String code) {
    switch(code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return const AppException(
          ErrorsStrings.emailOrPassword,
        );
      case 'invalid-email':
        return const AppException(
          ErrorsStrings.invalidEmailError,
        );
      case 'user-disabled':
        return const AppException(
          ErrorsStrings.userDisabled,
        );
      case 'user-not-found':
        return const AppException(
          ErrorsStrings.userNotFound,
        );
      case 'wrong-password':
        return const AppException(
          ErrorsStrings.wrongPassword,
        );
      default:
        return const AppException();
    }
  }

  factory AppException.signInWithGoogleFailure(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const AppException(
          ErrorsStrings.accountExistsWithDifferentCredential,
        );
      case 'invalid-credential':
        return const AppException(
          ErrorsStrings.invalidCredential,
        );
      case 'operation-not-allowed':
        return const AppException(
          ErrorsStrings.operationNotAllowed,
        );
      case 'user-disabled':
        return const AppException(
          ErrorsStrings.userDisabled,
        );
      case 'user-not-found':
        return const AppException(
          ErrorsStrings.userNotFound,
        );
      case 'wrong-password':
        return const AppException(
          ErrorsStrings.wrongPassword,
        );
      case 'invalid-verification-code':
        return const AppException(
          ErrorsStrings.invalidVerificationCode,
        );
      case 'invalid-verification-id':
        return const AppException(
          ErrorsStrings.invalidVerificationId,
        );
      default:
        return const AppException();
    }
  }

  factory AppException.signUpFailure(String code) {
    switch (code) {
      case 'invalid-email':
        return const AppException(
          ErrorsStrings.invalidEmailError,
        );
      case 'user-disabled':
        return const AppException(
          ErrorsStrings.userDisabled,
        );
      case 'email-already-in-use':
        return const AppException(
          ErrorsStrings.emailAlreadyInUse,
        );
      case 'operation-not-allowed':
        return const AppException(
          ErrorsStrings.operationNotAllowed,
        );
      case 'weak-password':
        return const AppException(
          ErrorsStrings.weekPassword,
        );
      default:
        return const AppException();
    }
  }

  factory AppException.resetPasswordFailure(String code) {
    switch (code) {
      case 'invalid-email':
        return const AppException(
          ErrorsStrings.invalidEmailError,
        );
      case 'user-not-found':
        return const AppException(
          ErrorsStrings.userNotFound,
        );
      case 'too-many-requests':
        return const AppException(
          ErrorsStrings.tooManyRequests,
        );
      default:
        return const AppException(ErrorsStrings.emailNotSent);
    }
  }

  factory AppException.logOutFailure(String code) {
    return const AppException(ErrorsStrings.logoutFailure);
  }
}
