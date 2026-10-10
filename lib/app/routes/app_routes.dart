/// Route path constants. No screen or controller writes a path by hand.
///
/// A name is added here when a screen first needs it, even before the screen
/// that owns it exists, so screens can link to each other. It is registered
/// in `AppPages` only once its screen exists.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String logIn = '/log-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String addProfile = '/add-profile';
  static const String addMedication = '/add-medication';
}
