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
  String get enterPhoneNumber => 'Enter the phone number';

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

  @override
  String get productDescription => 'Description';

  @override
  String get productIncludes => 'Includes';

  @override
  String get productInStock => 'In Stock';

  @override
  String get productOutOfStock => 'Out of Stock';

  @override
  String get productAvailableStock => 'Available Stock';

  @override
  String get retry => 'Retry';

  @override
  String get search => 'Search';

  @override
  String get egp => 'EGP';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get bestSeller => 'Best Seller';

  @override
  String get bestSellerSubtitle => 'Bloom with our exquisite best sellers';

  @override
  String get occasion => 'Occasion';

  @override
  String get flowery => 'Flowery';

  @override
  String get deliverTo => 'Deliver to';

  @override
  String get viewAll => 'View All';

  @override
  String get bestSellers => 'Best Sellers';

  @override
  String get address => 'Address';

  @override
  String get locationPermissionNeeded => 'Location permission needed';

  @override
  String get allowAccessDescription =>
      'Allow access to auto-fill your address.';

  @override
  String get allowAccess => 'Allow access';

  @override
  String get couldntResolveAddress => 'Couldn\'t resolve address';

  @override
  String get couldntResolveAddressDescription =>
      'We found your coordinates but not a street address. Enter it manually below, or ';

  @override
  String get tryAgain => 'try again';

  @override
  String get findingLocation => 'Finding your location...';

  @override
  String get enterAddress => 'Enter the address';

  @override
  String get recipientName => 'Recipient name';

  @override
  String get enterRecipientName => 'Enter the recipient name';

  @override
  String get city => 'City';

  @override
  String get cairo => 'Cairo';

  @override
  String get area => 'Area';

  @override
  String get october => 'October';

  @override
  String get saveAddress => 'Save address';

  @override
  String get turnOnLocation => 'Turn on location';

  @override
  String get locationDisabledDescription =>
      'Your device\'s location service is off. Turn it on so we can find your address automatically.';

  @override
  String get enableLocation => 'Enable location';

  @override
  String get enterAddressManually => 'Enter address manually';

  @override
  String get locationAccessBlocked => 'Location access blocked';

  @override
  String get locationBlockedDescription =>
      'You\'ve turned off location for this app. Enable it in settings to use your current address.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get locationPermissionDeniedSettingsMessage =>
      'The location permission is permanently denied. Please enable it in settings to use the address auto-detection.';

  @override
  String get mapConfigWarning => 'High-quality maps are unavailable';

  @override
  String get mapConfigWarningDescription =>
      'Using basic map provider. Some map details may be missing.';
}
