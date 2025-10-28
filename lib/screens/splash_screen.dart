// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gobar/screens/auth/auth_screen.dart';
import 'package:gobar/screens/main_screen.dart';
import 'package:gobar/screens/onboarding_screen.dart';
import 'package:gobar/service/localstorage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _checkFlow();
  }

  Future<void> _checkFlow() async {
    await Future.delayed(const Duration(seconds: 4)); // имитация Splash

    final onboardingShown = await LocalStorage.isOnboardingShown();
    final token = await LocalStorage.getToken();

    Widget nextScreen;

    if (onboardingShown & (token != null)) {
      nextScreen = const MainScreen();
    } else if (onboardingShown & (token == null)) {
      nextScreen = const AuthScreen();
    } else {
      nextScreen = const OnboardingScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) => nextScreen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff363062),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: SizedBox(
            height: 220,
            width: 220,
            child: Column(
              children: [
                SvgPicture.asset('assets/icons/logo.svg'),
                const Text('Barberly', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
