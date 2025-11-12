// File: lib/shared/widgets/match_card.dart
// VERSI BARU - DENGAN LOGO TIM & FONT YANG DISESUAIKAN

import 'dart:ui'; // Import untuk ImageFilter
import 'package:flutter/material.dart';
import 'package:suhu_bola/core/models/match_model.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  
  const MatchCard({super.key, required this.match});

  // --- WIDGET HELPER BARU UNTUK LOGO + NAMA TIM ---
  Widget _buildTeamDisplay(BuildContext context, {
    required String logoUrl, 
    required String teamName
  }) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo Tim
        Image.network(
          logoUrl,
          height: 40, // Beri tinggi tetap
          width: 40,
          // Placeholder jika logo tidak ada/gagal
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.shield_outlined, 
              color: Colors.grey, 
              size: 40,
            );
          },
          // Placeholder saat loading
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child; // Gambar selesai
            return const SizedBox(
              height: 40,
              width: 40,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
            );
          },
        ),
        
        const SizedBox(height: 10), // Jarak antara logo dan nama

        // Nama Tim
        Text(
          teamName,
          textAlign: TextAlign.center,
          // --- UKURAN FONT DISESUAIKAN ---
          // Kita gunakan bodyMedium (14) yang lebih kecil tapi tebal
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), 
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
  // ---------------------------------------------

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    String scoreOrTime;
    bool isMatchPlayed = (match.homeScore != null && match.awayScore != null);
    
    if (isMatchPlayed) {
      scoreOrTime = "${match.homeScore} - ${match.awayScore}";
    } else {
      scoreOrTime = match.time.substring(0, 5); 
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
            ),
            child: Column(
              children: [
                // Baris Tim (seperti .fixture-teams)
                Row(
                  // Gunakan CrossAxisAlignment.start agar sejajar atas jika nama tim panjang
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // --- Tim Tuan Rumah (DIPERBARUI) ---
                    Expanded(
                      child: _buildTeamDisplay(
                        context,
                        logoUrl: match.homeTeamLogoUrl,
                        teamName: match.homeTeam,
                      ),
                    ),
                    
                    // Kotak Skor/Waktu
                    Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Beri margin vertikal
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 2,
                          )
                        ]
                      ),
                      child: Text(
                        scoreOrTime,
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: isMatchPlayed 
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                        ),
                      ),
                    ),

                    // --- Tim Tamu (DIPERBARUI) ---
                    Expanded(
                      child: _buildTeamDisplay(
                        context,
                        logoUrl: match.awayTeamLogoUrl,
                        teamName: match.awayTeam,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12), // Spasi
                
                // Baris Tanggal (seperti .fixture-date)
                Text(
                  match.date,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}