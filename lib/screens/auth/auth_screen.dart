import 'package:flutter/material.dart';
import 'package:barberly/screens/auth/login_screen.dart';
import 'package:barberly/screens/auth/sign_up_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeInBack,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.1, 0),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: isLogin
          ? LoginScreen(key: const ValueKey('login'), onTap: _toggleMode)
          : SignUpScreen(key: const ValueKey('signup'), onTap: _toggleMode),
    );
  }
}
