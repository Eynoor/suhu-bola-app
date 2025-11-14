import 'package:flutter/material.dart';
import 'package:suhu_bola/core/services/api_service.dart';

/// Provider untuk ApiService - singleton
/// Gunakan ini di MultiProvider di main.dart
class ApiServiceProvider extends ChangeNotifier {
  late final ApiService _apiService;

  ApiServiceProvider() {
    _apiService = ApiService();
  }

  ApiService get apiService => _apiService;
}
