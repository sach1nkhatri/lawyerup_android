class ApiEndpoints {
  ApiEndpoints._();

  /// Use 10.0.2.2 for Android Emulator
  static const String baseHost = "http://10.0.2.2:5000";
  static const String baseUrl = "$baseHost/api/";

  // Auth
  static const String login = "${baseUrl}auth/login";
  static const String register = "${baseUrl}auth/signup";
  static const String currentUser = "${baseUrl}auth/me";
  static const String updateProfile = "${baseUrl}auth/update-profile";

  // Static
  static const String uploads = "$baseHost/uploads/";

  // PDFs
  static const pdfList = 'pdfs';

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
  static const String getAllLawyers = "${baseUrl}lawyers";
  static const String createLawyer = "${baseUrl}lawyers";
  static String getLawyerById(String id) => "$baseUrl/lawyers/$id";
  static String updateLawyer(String id) => "$baseUrl/lawyers/$id";
  static String deleteLawyer(String id) => "$baseUrl/lawyers/$id";
  static const String getLawyerByUser = "${baseUrl}lawyers/by-user";

  //  Bookings
  static const String createBooking = "${baseUrl}bookings";
  static String getUserBookings(String userId) => "${baseUrl}bookings/user/$userId";
  static String getLawyerBookings(String lawyerId) => "${baseUrl}bookings/lawyer/$lawyerId";
  static String getAvailableSlots(String lawyerId, String date, int duration) =>
      "${baseUrl}bookings/slots?lawyerId=$lawyerId&date=$date&duration=$duration";
  static String updateBookingStatus(String bookingId) =>
      "${baseUrl}bookings/$bookingId/status";
  static String updateMeetingLink(String bookingId) =>
      "${baseUrl}bookings/$bookingId/meeting-link";
  static String deleteBooking(String bookingId) => "${baseUrl}bookings/$bookingId";
  static String getChatMessages(String bookingId) => "${baseUrl}bookings/$bookingId/chat";
  static String sendMessage(String bookingId) => "${baseUrl}bookings/$bookingId/chat";
  static String markMessagesRead(String bookingId) =>
      "${baseUrl}bookings/$bookingId/chat/read";

  //JoinAsALawyer

// AI Chat
  static const String getChats = "${baseUrl}ai/chats";
  static String deleteChat(String chatId) => "${baseUrl}ai/chats/$chatId";



}
