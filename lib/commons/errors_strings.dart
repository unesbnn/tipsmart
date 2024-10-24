class ErrorsStrings {
  //Authentication Errors Strings
  static const String invalidEmailError = 'Email is not valid or badly formatted.';
  static const String userDisabled = 'his user has been disabled. Please contact support for help.';
  static const String userNotFound = 'Email is not found, please create an account.';
  static const String wrongPassword = 'Incorrect password, please try again.';
  static const String emailOrPassword = 'Incorrect email or password, please try again.';
  static const String accountExistsWithDifferentCredential = 'Account exists with different credentials.';
  static const String invalidCredential = 'The credential received is malformed or has expired.';
  static const String operationNotAllowed = 'Operation is not allowed.  Please contact support.';
  static const String invalidVerificationCode = 'The credential verification code received is invalid.';
  static const String invalidVerificationId = 'The credential verification ID received is invalid.';
  static const String emailAlreadyInUse = 'An account already exists for that email.';
  static const String weekPassword = 'Please enter a stronger password.';
  static const String tooManyRequests = 'Too many requests, please try again later.';
  static const String emailNotSent = 'Email was not sent due an unknown error.';
  static const String unknownError = 'An unknown error occurred.';
  static const String logoutFailure = 'An unknown exception occurred while signing out.';

  //Validation Errors Strings
  static const String kEmptyEmail = 'Please enter your email';
  static const String kInvalidEmail = 'Please enter a valid email';
  static const String kEmptyPassword = 'Please enter your password';
  static const String kInvalidPassword = 'Passwords must be at least 8 characters long';
}