
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "http://localhost:3000/api/v1/";

  // Auth endpoints
  static const String login = "\${baseUrl}auth/login";
  static const String register = "\${baseUrl}auth/register";
}
