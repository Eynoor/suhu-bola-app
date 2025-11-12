class TopScorerModel {
  final String playerName;
  final String teamName;
  final String teamBadgeUrl;
  final int goals;
  final int assists;
  final int penalties;

  TopScorerModel({
    required this.playerName,
    required this.teamName,
    required this.teamBadgeUrl,
    required this.goals,
    required this.assists,
    required this.penalties,
  });

  factory TopScorerModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> player = json['player'] ?? {};
    final Map<String, dynamic> team = json['team'] ?? {};

    return TopScorerModel(
      playerName: player['name'] ?? 'Nama Pemain Tidak Ditemukan',
      teamName: team['name'] ?? 'Nama Tim Tidak Ditemukan',
      teamBadgeUrl: team['crest'] ?? '',
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      penalties: json['penalties'] ?? 0,
    );
  }
}
