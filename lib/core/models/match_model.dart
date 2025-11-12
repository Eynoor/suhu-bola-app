// File: lib/core/models/match_model.dart
// VERSI BARU - DENGAN 'unused_import' DIHAPUS

// import 'package:flutter/foundation.dart'; // <-- DIHAPUS
import 'package:intl/intl.dart'; 

class MatchModel {
  final String eventName;
  final String homeTeam;
  final String awayTeam;
  final String? homeScore;
  final String? awayScore;
  final String date;
  final String time;
  final String status;
  
  final String homeTeamLogoUrl;
  final String awayTeamLogoUrl;

  MatchModel({
    required this.eventName,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    required this.date,
    required this.time,
    required this.status,
    required this.homeTeamLogoUrl,
    required this.awayTeamLogoUrl,
  });

  // --- Helper Functions (Tidak Berubah) ---
  static String _formatDate(String? utcDate) {
    if (utcDate == null) return 'No Date';
    try {
      final dateTime = DateTime.parse(utcDate).toLocal();
      // Format: 2025-11-15
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  static String _formatTime(String? utcDate) {
    if (utcDate == null) return 'No Time';
    try {
      final dateTime = DateTime.parse(utcDate).toLocal();
      // Format: 15:00
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return 'Invalid Time';
    }
  }
  // ---------------------------------------------------

  // --- FACTORY DIPERBARUI UNTUK MENGAMBIL LOGO ---
  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> homeTeam = json['homeTeam'] ?? {};
    final Map<String, dynamic> awayTeam = json['awayTeam'] ?? {};
    final Map<String, dynamic> score = json['score']?['fullTime'] ?? {};
    final String utcDate = json['utcDate'] ?? '';

    final String homeName = homeTeam['name'] ?? 'Home';
    final String awayName = awayTeam['name'] ?? 'Away';
    final String eventName = '$homeName vs $awayName';

    final String homeLogo = homeTeam['crest'] ?? '';
    final String awayLogo = awayTeam['crest'] ?? '';

    final String? homeScore = score['home']?.toString();
    final String? awayScore = score['away']?.toString();

    return MatchModel(
      eventName: eventName,
      homeTeam: homeName,
      awayTeam: awayName,
      homeScore: homeScore,
      awayScore: awayScore,
      date: _formatDate(utcDate), 
      time: _formatTime(utcDate),
      status: json['status'] ?? 'SCHEDULED',
      homeTeamLogoUrl: homeLogo,
      awayTeamLogoUrl: awayLogo,
    );
  }
}