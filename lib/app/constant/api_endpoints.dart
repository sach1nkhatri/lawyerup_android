class ApiEndpoints {
  ApiEndpoints._();

  /// Use 10.0.2.2 for Android Emulator
  static const String baseHost = "http://10.0.2.2:5000"; // for Android emulator
  // static const String baseHost = "http://localhost:5000"; // for web/desktop

  static const String baseUrl = "$baseHost/api/";

  // Auth
  static const String login = "${baseUrl}auth/login";
  static const String register = "${baseUrl}auth/signup";
  static const String currentUser = "${baseUrl}auth/me";
  static const String updateProfile = "${baseUrl}auth/update-profile";

  // Static
  static const String uploads = "$baseHost/uploads/";
}
