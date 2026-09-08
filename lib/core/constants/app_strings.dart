abstract final class AppStrings {
  static const String appName = 'Flowery';

  // API Response Messages
  static const generalErrorMessage =
      'Something went wrong. Please try again later.';
  static const connectionErrorMessage =
      'Connection timeout. Please check your internet connection and try again.';
  static const noConnectionErrorMessage =
      'No internet connection. Please check your network and try again.';
  static const securityErrorMessage = 'Security error. Please try again later.';
  static const cancelErrorMessage = 'Request was cancelled.';

  // Status Code Messages
  static const code400Message =
      'Invalid information. Please check your details and try again.';
  static const code401Message =
      'Session expired or invalid credentials. Please log in again.';

  static const code403Message =
      'You don\'t have permission to perform this action.';
  static const code404Message =
      'Requested resource not found. Please try again later.';
  static const code409Message =
      'This account already exists. Try logging in instead.';
  static const code422Message = 'Please check your information and try again.';
  static const code429Message =
      'Too many attempts. Please wait a moment before trying again.';
  static const code500sMessage =
      'Server is temporarily unavailable. Please try again in a few moments.';

  static const String addressNotFoundMessage =
      'We couldn\'t find a specific address for this location. Please try entering it manually.';
}
