import 'package:barberly/core/network/api_service.dart';
import 'package:barberly/features/auth/providers/auth_provider.dart';
import 'package:barberly/features/auth/screens/auth_screen.dart';
import 'package:barberly/features/auth/screens/otp_screen.dart';
import 'package:barberly/features/main_screen.dart';
import 'package:barberly/features/splash_screen.dart';
import 'package:barberly/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final api = ApiService();
  await api.loadToken();
  runApp(
    ProviderScope(
      overrides: [apiServiceProvider.overrideWithValue(api)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(textTheme: GoogleFonts.plusJakartaSansTextTheme()),
      debugShowCheckedModeBanner: false,

      routes: {
        '/main': (context) =>  MainScreen(),
        '/otp': (context) => const OtpScreen(),
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}
