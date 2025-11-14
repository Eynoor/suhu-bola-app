import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suhu_bola/shared/widgets/match_card.dart';
import 'package:suhu_bola/core/models/match_model.dart';

void main() {
  testWidgets('MatchCard renders team names and score',
      (WidgetTester tester) async {
    const match = MatchModel(
      eventName: 'Test Match',
      homeTeam: 'Home FC',
      awayTeam: 'Away United',
      homeScore: '1',
      awayScore: '2',
      date: '2025-11-15',
      time: '20:00',
      status: 'FINISHED',
      homeTeamLogoUrl: '',
      awayTeamLogoUrl: '',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MatchCard(match: match),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Home FC'), findsOneWidget);
    expect(find.text('Away United'), findsOneWidget);
    expect(find.text('SELESAI'), findsOneWidget);
  });
}
