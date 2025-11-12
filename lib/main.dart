// File: lib/main.dart
// VERSI FINAL - TEMA PREMIUM "SLATE & GRADIENT" (LENGKAP)

import 'package:flutter/material.dart';
import 'package:suhu_bola/features/home/home_screen.dart';
import 'package:google_fonts/google_fonts.dart'; // Import font baru

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA BARU (DARI HTML ANDA) ---
    const Color primaryAccent = Color(0xFF06b6d4); // Cyan
    const Color secondaryAccent = Color(0xFF3b82f6); // Biru
    const Color backgroundDark = Color(0xFF0f172a); // Dark Slate (Body)
    const Color backgroundMedium = Color(0xFF1e293b); // Medium Slate (Card)
    // ------------------------------------

    // Buat tema teks dasar menggunakan Google Fonts (premium typography)
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SUHU BOLA',
      
      theme: ThemeData.dark().copyWith(
        // Terapkan font premium
        textTheme: textTheme.copyWith(
          // Judul besar (misal: "Liga Inggris" di AppBar)
          titleLarge: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
          ),
          // Judul kartu (misal: "Liga Inggris" di Beranda)
          titleMedium: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
          // Teks di body (misal: nama tim)
          bodyMedium: textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
          ),
          // Teks sekunder (misal: "Lihat Jadwal")
          bodySmall: textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: Colors.grey[400],
          ),
          // Teks di header tabel (M, W, D, L)
          labelSmall: textTheme.labelSmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey[500],
            letterSpacing: 1,
          ),
        ),
        
        // Warna utama
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryAccent,
          primary: primaryAccent,
          secondary: secondaryAccent,
          brightness: Brightness.dark,
        ),
        
        // Background utama
        scaffoldBackgroundColor: backgroundDark,
        
        // AppBar (kita akan ganti ini dengan gradient di tiap halaman)
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundMedium, // Warna fallback
          elevation: 0,
          centerTitle: false, // Judul di kiri
        ),
        
        // 
        // --- INI ADALAH TEMA TABBAR YANG SUDAH DIPERBAIKI ---
        //
        tabBarTheme: TabBarTheme(
          // Ini untuk "pill" yang aktif (seperti .tab.active)
          indicator: BoxDecoration(
            color: Colors.white, // Pil warna putih
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [ // Beri bayangan agar lebih menonjol
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          
          // Ukuran indikator harus mengisi seluruh 'tab'
          indicatorSize: TabBarIndicatorSize.tab, 
          
          // Warna teks aktif (sesuai HTML .tab.active color)
          labelColor: const Color(0xFF06b6d4), // Cyan
          
          // Warna teks tidak aktif (sesuai HTML .tab.inactive color)
          unselectedLabelColor: Colors.white, 
          
          // Pastikan style-nya konsisten
          labelStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      
      home: const HomeScreen(),
    );
  }
}