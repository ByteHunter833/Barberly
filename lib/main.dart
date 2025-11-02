import 'package:barberly/auth/auth_screen.dart';
import 'package:barberly/auth/otp_screen.dart';
import 'package:barberly/firebase_options.dart';
import 'package:barberly/roles/splash_screen.dart';
import 'package:barberly/roles/user/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
