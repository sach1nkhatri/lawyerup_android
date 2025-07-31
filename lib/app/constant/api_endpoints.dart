class ApiEndpoints {
  ApiEndpoints._();

  /// Use 10.0.2.2 for Android Emulator http://192.168.1.67:5000 http://10.0.2.2:5000
  static const String baseHost =  "http://192.168.1.85:5000";
  static const String baseUrl = "$baseHost/api/";
//pdf
  static const String staticHost = "http://192.168.1.85:5000";
  // Socket
  static const String socketUrl = "http://192.168.1.85:5000";


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
  static const String getLawyerByMe = "${baseUrl}lawyers/me";



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



// AI Chat
  static const String getChats = "${baseUrl}ai/chats";
  static String deleteChat(String chatId) => "${baseUrl}ai/chats/$chatId";
  static String sendAiMessage(String chatId) => "${baseUrl}ai/send";
  static const String saveReply = "${baseUrl}ai/saveReply";


// Reviews
  static String submitReview(String bookingId) => "${baseUrl}reviews/$bookingId";
  // FAQs
  static const String getFaqs = "${baseUrl}faqs";

  // Settings / Danger Zone
  static const String clearUserBookingChat = "${baseUrl}bookings/clear-user-history";
  static const String clearAiChat = "${baseUrl}ai/chats/all";
  static const String deleteAccount = "${baseUrl}delete/account";
  //payment
  static const String manualPayment = "${baseUrl}manual-payment";
  //report
  static const String report = "${baseUrl}report";


//Third Party Api For Ai chat


  // LM Studio / Local AI
  static const String lmStudioBase = "http://192.168.1.85:1234";
  static const String chatCompletions = "$lmStudioBase/v1/chat/completions";



}
