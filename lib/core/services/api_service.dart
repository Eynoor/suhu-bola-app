// File: lib/core/services/api_service.dart
// VERSI BARU - MIGRASI TOTAL KE FOOTBALL-DATA.ORG

import 'package:dio/dio.dart';
import 'package:suhu_bola/core/models/match_model.dart';
import 'package:suhu_bola/core/models/standings_model.dart';

class ApiService {
  // --- KONFIGURASI API BARU ---
  final Dio _dio;
  final String _baseUrl = 'https://api.football-data.org/v4';
  
  // Ganti dengan API Key Anda dari email
  final String _apiKey = 'a46962e140bc4cc184a1f6a67f0ea342'; 

  // Peta untuk menerjemahkan ID lama kita ke kode API baru
  final Map<String, String> _leagueCodes = {
    '4328': 'PL',   // Liga Inggris
    '4335': 'PD',   // Liga Spanyol
    '4332': 'SA',   // Liga Italia
    '4331': 'BL1',  // Liga Jerman
    '4334': 'FL1',  // Liga Perancis
  };
  // -----------------------------

  // Constructor: Mengatur Dio dengan Header
  ApiService() : _dio = Dio() {
    _dio.options.headers['X-Auth-Token'] = _apiKey;
    _dio.options.baseUrl = _baseUrl;
  }

  //
  // --- FUNGSI JADWAL (DITULIS ULANG) ---
  //
  Future<List<MatchModel>> getScheduleByLeague(String leagueId) async {
    final String leagueCode = _leagueCodes[leagueId] ?? 'PL'; // Default ke PL
    
    try {
      // Endpoint baru: /competitions/{leagueCode}/matches
      final response = await _dio.get('/competitions/$leagueCode/matches');

      if (response.statusCode == 200 && response.data['matches'] is List) {
        final List matchesList = response.data['matches'];
        // Kita kirim data mentah ke MatchModel.fromJson yang baru
        return matchesList.map((e) => MatchModel.fromJson(e)).toList();
      } else {
        return []; // Kembalikan list kosong jika tidak ada data
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load schedule: $e');
    }
  }

  //
  // --- FUNGSI KLASEMEN (DITULIS ULANG) ---
  //
  Future<List<StandingsModel>> getStandingsByLeague(
    String leagueId, 
    String season, // season sekarang adalah '2023', '2022', dll.
  ) async {
    final String leagueCode = _leagueCodes[leagueId] ?? 'PL';

    try {
      // Endpoint baru: /competitions/{leagueCode}/standings?season={YYYY}
      final response = await _dio.get(
        '/competitions/$leagueCode/standings',
        queryParameters: {'season': season}, // Kirim musim sebagai query
      );

      // Struktur JSON baru sangat berbeda
      // Datanya ada di dalam response.data['standings'][0]['table']
      if (response.statusCode == 200 && 
          response.data['standings'] is List && 
          (response.data['standings'] as List).isNotEmpty) {
        
        final List tableList = response.data['standings'][0]['table'];
        
        // Kita kirim data mentah ke StandingsModel.fromJson yang baru
        // Kita akan dapat 20 TIM SEKARANG!
        return tableList.map((e) => StandingsModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load standings: $e');
    }
  }
}