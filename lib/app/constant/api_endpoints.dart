class ApiEndpoints {
  ApiEndpoints._();

  /// Use 10.0.2.2 for Android Emulator
  static const String baseHost = "http://10.0.2.2:5000";
  // static const String baseHost = "http://localhost:5000";

  static const pdfList = 'pdfs'; // 👈 Just 'pdfs', not full path

  static const String baseUrl = "$baseHost/api/";

  // Auth
  static const String login = "${baseUrl}auth/login";
  static const String register = "${baseUrl}auth/signup";
  static const String currentUser = "${baseUrl}auth/me";
  static const String updateProfile = "${baseUrl}auth/update-profile";

  // Static
  static const String uploads = "$baseHost/uploads/";

  // News
  static const String getAllNews = "${baseUrl}news";
  static String likeNews(String id) => "${baseUrl}news/$id/like";
  static String unlikeNews(String id) => "${baseUrl}news/$id/unlike";
  static String dislikeNews(String id) => "${baseUrl}news/$id/dislike";
  static String undislikeNews(String id) => "${baseUrl}news/$id/undislike";
  static String commentNews(String id) => "${baseUrl}news/$id/comment";
  static String deleteComment(String newsId, int index) =>
      "${baseUrl}news/$newsId/comment/$index";

  // Lawyer
  static const String getAllLawyers = "${baseUrl}lawyers"; // for listing
  static const String createLawyer = "${baseUrl}lawyers"; // For POST

  static String getLawyerById(String id) => "$baseUrl/lawyers/$id";
  static String updateLawyer(String id) => "$baseUrl/lawyers/$id";
  static String deleteLawyer(String id) => "$baseUrl/lawyers/$id";
  static const String getLawyerByUser = "${baseUrl}lawyers/by-user"; // Optional

}
