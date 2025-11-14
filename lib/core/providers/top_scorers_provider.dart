import 'package:flutter/material.dart';
import 'package:suhu_bola/core/models/top_scorer_model.dart';
import 'package:suhu_bola/core/services/api_service.dart';

/// Provider untuk Top Scorers data setiap liga
/// State management untuk data top scorer
class TopScorersProvider extends ChangeNotifier {
  final ApiService _apiService;
  late Map<String, List<TopScorerModel>> _topScorersCache;
  late Map<String, bool> _loadingMap;
  late Map<String, String?> _errorMap;

  TopScorersProvider(this._apiService) {
    _topScorersCache = {};
    _loadingMap = {};
    _errorMap = {};
  }

  /// Get top scorers untuk liga dan season tertentu
  List<TopScorerModel> getTopScorers(String cacheKey) =>
      _topScorersCache[cacheKey] ?? [];

  bool isLoading(String cacheKey) => _loadingMap[cacheKey] ?? false;

  String? getError(String cacheKey) => _errorMap[cacheKey];

  /// Fetch top scorers dari API
  Future<void> fetchTopScorers(String leagueId, String season) async {
    final cacheKey = '$leagueId-$season';

    if (_topScorersCache.containsKey(cacheKey)) {
      return; // Already cached
    }

    _loadingMap[cacheKey] = true;
    _errorMap[cacheKey] = null;
    notifyListeners();

    try {
      final topScorers =
          await _apiService.getTopScorersByLeague(leagueId, season);
      _topScorersCache[cacheKey] = topScorers;
    } catch (e) {
      _errorMap[cacheKey] = e.toString();
    } finally {
      _loadingMap[cacheKey] = false;
      notifyListeners();
    }
  }

  /// Clear cache (opsional untuk refresh)
  void clearTopScorers(String leagueId, String season) {
    final cacheKey = '$leagueId-$season';
    _topScorersCache.remove(cacheKey);
    _loadingMap.remove(cacheKey);
    _errorMap.remove(cacheKey);
    notifyListeners();
  }
}
