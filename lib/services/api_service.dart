import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static String? _token;

  // Save token to local storage
  static Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get token from local storage
  static Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  // Clear token (logout)
  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Save user data
  static Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user));
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  // Clear user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  // Get headers with auth token
  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Generic GET request
  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Generic POST request
  static Future<Map<String, dynamic>> post(
      String url, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Generic PUT request
  static Future<Map<String, dynamic>> put(
      String url, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Generic DELETE request
  static Future<Map<String, dynamic>> delete(String url) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(Uri.parse(url), headers: headers);
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Handle API response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Request failed',
        'statusCode': response.statusCode,
      };
    }
  }

  // ============ AUTH METHODS ============

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final result = await post(ApiConfig.login, {
      'username': username,
      'password': password,
    });

    if (result['success'] == true) {
      await saveToken(result['token']);
      await saveUserData(result['user']);
    }

    return result;
  }

  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    return await post(ApiConfig.signup, {
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
      'phone': phone,
    });
  }

  static Future<void> logout() async {
    await clearToken();
    await clearUserData();
  }

  // ============ CARS METHODS ============

  static Future<Map<String, dynamic>> getCars({
    String? status,
    String? brand,
    double? minPrice,
    double? maxPrice,
  }) async {
    String url = ApiConfig.cars;
    List<String> params = [];

    if (status != null) params.add('status=$status');
    if (brand != null) params.add('brand=$brand');
    if (minPrice != null) params.add('minPrice=$minPrice');
    if (maxPrice != null) params.add('maxPrice=$maxPrice');

    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }

    return await get(url);
  }

  static Future<Map<String, dynamic>> getCarDetails(int carId) async {
    return await get(ApiConfig.carDetails(carId));
  }

  static Future<Map<String, dynamic>> getFavoriteCars() async {
    return await get(ApiConfig.favorites);
  }

  static Future<Map<String, dynamic>> addToFavorites(int carId) async {
    return await post(ApiConfig.addFavorite(carId), {});
  }

  static Future<Map<String, dynamic>> removeFromFavorites(int carId) async {
    return await delete(ApiConfig.removeFavorite(carId));
  }

  // ============ BOOKINGS METHODS ============

  static Future<Map<String, dynamic>> createBooking({
    required int carId,
    required String startDate,
    required String endDate,
    String? pickupLocation,
    double? pickupLat,
    double? pickupLon,
    String? phone,
    String? paymentMethod,
    String? notes,
  }) async {
    return await post(ApiConfig.bookings, {
      'carId': carId,
      'startDate': startDate,
      'endDate': endDate,
      'pickupLocation': pickupLocation,
      'pickupLat': pickupLat,
      'pickupLon': pickupLon,
      'phone': phone,
      'paymentMethod': paymentMethod,
      'notes': notes,
    });
  }

  static Future<Map<String, dynamic>> getBookings() async {
    return await get(ApiConfig.bookings);
  }

  static Future<Map<String, dynamic>> getBookingDetails(int bookingId) async {
    return await get(ApiConfig.bookingDetails(bookingId));
  }

  static Future<Map<String, dynamic>> getBookingHistory() async {
    return await get(ApiConfig.bookingHistory);
  }

  static Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    return await delete(ApiConfig.bookingDetails(bookingId));
  }

  // ============ NOTIFICATIONS METHODS ============

  static Future<Map<String, dynamic>> getNotifications() async {
    return await get(ApiConfig.notifications);
  }

  static Future<Map<String, dynamic>> getUnreadCount() async {
    return await get(ApiConfig.unreadCount);
  }

  static Future<Map<String, dynamic>> markNotificationAsRead(int id) async {
    return await put(ApiConfig.markAsRead(id), {});
  }

  // ============ USER METHODS ============

  static Future<Map<String, dynamic>> getProfile() async {
    return await get(ApiConfig.profile);
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phone,
    String? address,
    String? email,
  }) async {
    return await put(ApiConfig.profile, {
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'email': email,
    });
  }

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await put(ApiConfig.changePassword, {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  // ============ FEEDBACK METHODS ============

  static Future<Map<String, dynamic>> submitFeedback({
    required int rating,
    String? comment,
    int? bookingId,
  }) async {
    return await post(ApiConfig.feedback, {
      'rating': rating,
      'comment': comment,
      'bookingId': bookingId,
    });
  }

  static Future<Map<String, dynamic>> getMyFeedback() async {
    return await get(ApiConfig.myFeedback);
  }

  // ============ REQUESTS METHODS ============

  static Future<Map<String, dynamic>> createRequest({
    required String type,
    required String subject,
    required String description,
    String? priority,
  }) async {
    return await post(ApiConfig.requests, {
      'type': type,
      'subject': subject,
      'description': description,
      'priority': priority ?? 'medium',
    });
  }

  static Future<Map<String, dynamic>> getRequests() async {
    return await get(ApiConfig.requests);
  }

  // ============ DELIVERIES METHODS ============

  static Future<Map<String, dynamic>> getDeliveries() async {
    return await get(ApiConfig.deliveries);
  }

  // ============ EMPLOYEES METHODS (Manager only) ============

  static Future<Map<String, dynamic>> createEmployee({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? role,
    String? address,
  }) async {
    return await post(ApiConfig.employees, {
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
      'phone': phone,
      'role': role ?? 'employee',
      'address': address,
    });
  }

  static Future<Map<String, dynamic>> getEmployees() async {
    return await get(ApiConfig.employees);
  }

  // ============ HEALTH CHECK ============

  static Future<bool> checkConnection() async {
    try {
      final response = await get(ApiConfig.health);
      return response['status'] == 'ok';
    } catch (e) {
      return false;
    }
  }
}

