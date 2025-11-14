import 'package:flutter/material.dart';
import 'package:suhu_bola/core/models/standings_model.dart';
import 'package:suhu_bola/core/services/api_service.dart';

/// Provider untuk Standings data setiap liga
/// State management untuk klasemen pertandingan
class StandingsProvider extends ChangeNotifier {
  final ApiService _apiService;
  late Map<String, List<StandingsModel>> _standingsCache;
  late Map<String, bool> _loadingMap;
  late Map<String, String?> _errorMap;

  StandingsProvider(this._apiService) {
    _standingsCache = {};
    _loadingMap = {};
    _errorMap = {};
  }

  /// Get standings untuk liga dan season tertentu
  List<StandingsModel> getStandings(String cacheKey) =>
      _standingsCache[cacheKey] ?? [];

  bool isLoading(String cacheKey) => _loadingMap[cacheKey] ?? false;

  String? getError(String cacheKey) => _errorMap[cacheKey];

  /// Fetch standings dari API
  Future<void> fetchStandings(String leagueId, String season) async {
    final cacheKey = '$leagueId-$season';

    if (_standingsCache.containsKey(cacheKey)) {
      return; // Already cached
    }

    _loadingMap[cacheKey] = true;
    _errorMap[cacheKey] = null;
    notifyListeners();

    try {
      final standings =
          await _apiService.getStandingsByLeague(leagueId, season);
      _standingsCache[cacheKey] = standings;
    } catch (e) {
      _errorMap[cacheKey] = e.toString();
    } finally {
      _loadingMap[cacheKey] = false;
      notifyListeners();
    }
  }

  /// Clear cache (opsional untuk refresh)
  void clearStandings(String leagueId, String season) {
    final cacheKey = '$leagueId-$season';
    _standingsCache.remove(cacheKey);
    _loadingMap.remove(cacheKey);
    _errorMap.remove(cacheKey);
    notifyListeners();
  }
}
