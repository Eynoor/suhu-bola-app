import 'package:flutter/material.dart';
import 'package:suhu_bola/core/models/match_model.dart';
import 'package:suhu_bola/core/services/api_service.dart';

/// Provider untuk Schedule data setiap liga
/// State management untuk jadwal pertandingan
class ScheduleProvider extends ChangeNotifier {
  final ApiService _apiService;
  late Map<String, List<MatchModel>> _scheduleCache;
  late Map<String, bool> _loadingMap;
  late Map<String, String?> _errorMap;

  ScheduleProvider(this._apiService) {
    _scheduleCache = {};
    _loadingMap = {};
    _errorMap = {};
  }

  /// Get schedule untuk liga tertentu
  List<MatchModel> getSchedule(String leagueId) =>
      _scheduleCache[leagueId] ?? [];

  bool isLoading(String leagueId) => _loadingMap[leagueId] ?? false;

  String? getError(String leagueId) => _errorMap[leagueId];

  /// Fetch schedule dari API
  Future<void> fetchSchedule(String leagueId) async {
    if (_scheduleCache.containsKey(leagueId)) {
      return; // Already cached
    }

    _loadingMap[leagueId] = true;
    _errorMap[leagueId] = null;
    notifyListeners();

    try {
      final schedule = await _apiService.getScheduleByLeague(leagueId);
      _scheduleCache[leagueId] = schedule;
    } catch (e) {
      _errorMap[leagueId] = e.toString();
    } finally {
      _loadingMap[leagueId] = false;
      notifyListeners();
    }
  }

  /// Clear cache (opsional untuk refresh)
  void clearSchedule(String leagueId) {
    _scheduleCache.remove(leagueId);
    _loadingMap.remove(leagueId);
    _errorMap.remove(leagueId);
    notifyListeners();
  }
}
