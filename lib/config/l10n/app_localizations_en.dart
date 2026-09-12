// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get home => 'Home';

  @override
  String get categories => 'Categories';

  @override
  String get cart => 'Cart';

  @override
  String get profile => 'Profile';

  @override
  String get generalValidationError => 'Invalid input';

  @override
  String get emptyValidationError => 'This field is required';

  @override
  String get signup => 'Sign up';

  @override
  String get firstName => 'First name';

  @override
  String get enterFirstName => 'Enter first name';

  @override
  String get lastName => 'Last name';

  @override
  String get enterLastName => 'Enter last name';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get invalidEmailError => 'This Email is not valid';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get gender => 'Gender';

  @override
  String get female => 'Female';

  @override
  String get male => 'Male';

  @override
  String get termsAndConditionsPrefix =>
      'Creating an account, you agree to our ';

  @override
  String get termsAndConditions => 'Terms&Conditions';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get passwordLengthError => 'Password must be at least 8 characters';

  @override
  String get passwordUppercaseError =>
      'Password must contain at least 1 uppercase letter (A-Z)';

  @override
  String get passwordLowercaseError =>
      'Password must contain at least 1 lowercase letter (a-z)';

  @override
  String get passwordNumberError =>
      'Password must contain at least 1 number (0-9)';

  @override
  String get passwordSpecialCharError =>
      'Password must contain at least 1 special character (#?!@\$%^&*-)';

  @override
  String get registrationSuccessful => 'Registration Successful!';

  @override
  String get passwordsDoNotMatchError => 'Passwords do not match';

  @override
  String get loginRequired => 'Login required';

  @override
  String get loginRequiredMessage => 'Please login to use this feature.';

  @override
  String get cancel => 'Cancel';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgetPassword => 'Forget Password?';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get dontHaveAccount => 'Don\'t have account? ';

  @override
  String get signUp => 'Sign up';

  @override
  String get loginSuccessfully => 'Login Successfully';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgetPasswordText => 'Forgot Password';

  @override
  String get forgotPasswordDescription =>
      'Enter your email address and we will send you an OTP.';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get otp => 'OTP';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String otpSentTo(Object email) {
    return 'Enter the OTP sent to $email';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String resendOtpIn(Object seconds) {
    return 'Resend OTP in $seconds seconds';
  }

  @override
  String get invalidOtp => 'OTP must contain 6 digits';

  @override
  String get seconds => 'seconds';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'Password must be at least 8 characters';

  @override
  String get passwordMustContainUppercase =>
      'Password must contain an uppercase letter';

  @override
  String get passwordMustContainLowercase =>
      'Password must contain a lowercase letter';

  @override
  String get passwordMustContainNumber => 'Password must contain a number';

  @override
  String get passwordMustContainSpecialCharacter =>
      'Password must contain a special character';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordResetSuccessfully => 'Password reset successfully';
}
