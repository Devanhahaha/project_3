import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  // Private constructor
  PreferencesHelper._privateConstructor();

  // Single instance of PreferencesHelper
  static final PreferencesHelper _instance = PreferencesHelper._privateConstructor();

  // Getter for the single instance
  static PreferencesHelper get instance => _instance;

  // SharedPreferences instance
  SharedPreferences? _preferences;

  // Initialize SharedPreferences instance once
  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // Keys for stored data
  static const String _keyAccessToken = 'access_token';
  static const String _keyUserData = 'user_data';

  // Method to save access_token
  Future<void> saveAccessToken(String token) async {
    await _preferences?.setString(_keyAccessToken, token);
  }

  // Method to retrieve access_token
  String? get accessToken => _preferences?.getString(_keyAccessToken);

  // Method to save user data (in JSON format or any string format)
  Future<void> saveUserData(String userData) async {
    await _preferences?.setString(_keyUserData, userData);
  }

  // Method to retrieve user data
  String? get userData => _preferences?.getString(_keyUserData);

  // Method to clear all login-related data
  Future<void> clearLoginData() async {
    await _preferences?.remove(_keyAccessToken);
    await _preferences?.remove(_keyUserData);
  }
}
