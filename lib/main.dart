import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gobar/firebase_options.dart';
import 'package:gobar/screens/auth/auth_screen.dart';
import 'package:gobar/screens/auth/otp_screen.dart';
import 'package:gobar/screens/main_screen.dart';
import 'package:gobar/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
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
        '/main': (context) => const MainScreen(),
        '/otp': (context) => const OtpScreen(),
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}
