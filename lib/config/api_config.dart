class ApiConfig {
  // Base URL - Change this based on your environment
  // For Android Emulator: http://10.0.2.2:3000
  // For iOS Simulator: http://localhost:3000
  // For Physical Device: http://YOUR_COMPUTER_IP:3000
  static const String baseUrl = 'http://192.168.2.19:3000';
  
  // API Endpoints
  static const String apiBase = '$baseUrl/api';
  
  // Auth endpoints
  static const String login = '$apiBase/auth/login';
  static const String signup = '$apiBase/auth/signup';
  
  // Cars endpoints
  static const String cars = '$apiBase/cars';
  static String carDetails(int id) => '$cars/$id';
  static const String favorites = '$cars/favorites/list';
  static String addFavorite(int carId) => '$cars/favorites/$carId';
  static String removeFavorite(int carId) => '$cars/favorites/$carId';
  
  // Bookings endpoints
  static const String bookings = '$apiBase/bookings';
  static String bookingDetails(int id) => '$bookings/$id';
  static String bookingStatus(int id) => '$bookings/$id/status';
  static const String bookingHistory = '$bookings/history/user';
  
  // Deliveries endpoints
  static const String deliveries = '$apiBase/deliveries';
  static String deliveryDetails(int id) => '$deliveries/$id';
  
  // Requests endpoints
  static const String requests = '$apiBase/requests';
  static String requestDetails(int id) => '$requests/$id';
  
  // Employees endpoints
  static const String employees = '$apiBase/employees';
  static String employeeDetails(int id) => '$employees/$id';
  
  // Notifications endpoints
  static const String notifications = '$apiBase/notifications';
  static const String unreadCount = '$notifications/unread/count';
  static String markAsRead(int id) => '$notifications/$id/read';
  
  // Users endpoints
  static const String profile = '$apiBase/users/profile';
  static const String changePassword = '$apiBase/users/change-password';
  static const String userStatistics = '$apiBase/users/statistics';
  
  // Feedback endpoints
  static const String feedback = '$apiBase/feedback';
  static const String myFeedback = '$feedback/my-feedback';
  static const String averageRating = '$feedback/average-rating';
  
  // Health check
  static const String health = '$apiBase/health';
}

