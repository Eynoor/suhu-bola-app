// File: lib/core/models/standings_model.dart
// VERSI IMMUTABLE - DENGAN @immutable & const constructor

import 'package:flutter/foundation.dart';

@immutable
class StandingsModel {
  final String teamName;
  final String teamBadgeUrl; // URL Logo
  final int rank;
  final int played;
  final int wins;
  final int draws;
  final int losses;
  final int points;

  const StandingsModel({
    required this.teamName,
    required this.teamBadgeUrl,
    required this.rank,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.points,
  });

  // --- FACTORY DITULIS ULANG TOTAL ---
  factory StandingsModel.fromJson(Map<String, dynamic> json) {
    // API baru mengirim data 'tim' di dalam sub-map
    final Map<String, dynamic> team = json['team'] ?? {};

    // API baru mengirim angka sebagai ANGKA (int), bukan String!
    // Kita tidak perlu 'parseInt' lagi.
    return StandingsModel(
      teamName: team['name'] ?? 'Nama Tim Tidak Ditemukan',
      teamBadgeUrl: team['crest'] ?? '', // Kunci baru adalah 'crest'
      rank: json['position'] ?? 0, // Kunci baru adalah 'position'
      played: json['playedGames'] ?? 0, // Kunci baru adalah 'playedGames'
      wins: json['won'] ?? 0,
      draws: json['draw'] ?? 0,
      losses: json['lost'] ?? 0, // Kunci baru adalah 'lost'
      points: json['points'] ?? 0,
    );
  }

  // Kita HAPUS 'copyWith' karena tidak diperlukan lagi.
}
