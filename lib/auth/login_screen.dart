// ignore_for_file: use_build_context_synchronously

import 'package:barberly/providers/api_service_provider.dart';
import 'package:barberly/roles/user/widgets/my_textfield.dart';
import 'package:barberly/services/localstorage_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_input/phone_input_package.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final void Function()? onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isObscured = true;
  final _passwordController = TextEditingController();
  final _phoneController = PhoneController(
    const PhoneNumber(isoCode: IsoCode.UZ, nsn: ''),
  );

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(String phone, String password) async {
    try {
      await ref.read(authControllerProvider.notifier).login(phone, password);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (prev, next) {
      next.status.whenOrNull(
        data: (data) async {
          final user = data['user']['name'];

          await LocalStorage.saveToken(data['token']);
          await LocalStorage.saveUsername(user);
          Navigator.pushReplacementNamed(context, '/main');
        },
        error: (err, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err.toString())));
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/surface_login.png',
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back 👋',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const Text(
                    'Please enter your login information below\nto access your account',
                    style: TextStyle(color: Color(0xff6B7280), fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Phone Number',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  PhoneInput(
                    countrySelectorNavigator:
                        const CountrySelectorNavigator.modalBottomSheet(),
                    defaultCountry: IsoCode.UZ,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xffD1D5DB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xff000000)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: PhoneValidator.validMobile(),
                    controller: _phoneController,
                  ),
                  const SizedBox(height: 10),
                  MyTextfield(
                    obscureText: isObscured,
                    hintText: '*****',
                    labelText: 'Password',
                    controller: _passwordController,
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured;
                        });
                      },
                      icon: isObscured
                          ? const Icon(Icons.visibility_off_outlined)
                          : const Icon(Icons.visibility_outlined),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xff363062),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 53,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff363062),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: authState.status.isLoading
                          ? null
                          : () async {
                              final phone =
                                  _phoneController.value?.international ?? '';
                              final password = _passwordController.text.trim();

                              await login(phone, password);
                            },
                      child: authState.status.isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color(0xff363062),
                          fontWeight: FontWeight.w500,
                        ),
                        text: "Don't have an account?",
                        children: [
                          TextSpan(
                            text: ' Register',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
