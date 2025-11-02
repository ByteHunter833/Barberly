// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:barberly/providers/api_service_provider.dart';
import 'package:barberly/services/localstorage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  int _seconds = 60;
  Timer? _timer;
  String? displayedCode; // Изменено на String? (OTP-код — строка, не int)

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Теперь context готов для inherited widgets (ModalRoute, providers)
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    displayedCode = args?['otp']['code']?.toString() ?? '';
  }

  void _startTimer() {
    _seconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        if (mounted) {
          setState(() => _seconds--); // Обновляем UI, если widget жив
        }
      }
    });
  }

  // Метод для очистки полей (через key формы)
  void _clearOtpFields() {
    final formState = _otpFormKey.currentState;
    formState?.clearFields();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  final GlobalKey<_OtpFormState> _otpFormKey =
      GlobalKey<_OtpFormState>(); // Key для формы

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final phone = args?['otp']['phone'] ?? '';

    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.status.whenOrNull(
        data: (data) async {
          debugPrint('Response: $data');

          /// If resend
          if (data['message'] == 'Yangi tasdiqlash kodi yuborildi') {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('New code sent!')));
            }
            setState(() {
              displayedCode = null; // Скрываем старый код
              _startTimer(); // Перезапуск таймера
            });
            _clearOtpFields(); // Очищаем поля OTP
            return;
          }

          /// Verify success
          if (data['token'] != null) {
            final user = data['user']['name'];
            await LocalStorage.saveToken(data['token']);
            await LocalStorage.saveUsername(user);
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/main',
                (route) => false,
              );
            }
          }
        },
        error: (error, _) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error.toString())));
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xffF9F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                const Text(
                  'Verification Code',
                  style: TextStyle(
                    color: Color(0xff363062),
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  displayedCode != null && displayedCode!.isNotEmpty
                      ? 'We sent a code to $phone: $displayedCode' // Показываем код, если есть
                      : 'New code sent to $phone', // После resend — без кода
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                OtpForm(
                  key: _otpFormKey,
                  onVerify: (code) {
                    ref
                        .read(authControllerProvider.notifier)
                        .verifyOtp(phone, code);
                  },
                  loading: authState.status.isLoading,
                ),

                const SizedBox(height: 30),

                /// RESEND BUTTON
                Center(
                  child: TextButton(
                    onPressed: _seconds > 0 || authState.status.isLoading
                        ? null
                        : () {
                            ref
                                .read(authControllerProvider.notifier)
                                .resendCode(phone);
                          },
                    child: Text(
                      _seconds > 0
                          ? 'Resend code in $_seconds s'
                          : 'Resend Code',
                      style: TextStyle(
                        fontSize: 16,
                        color: _seconds > 0
                            ? Colors.grey
                            : const Color(0xff363062),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// OTP FORM
class OtpForm extends StatefulWidget {
  final void Function(String code) onVerify;
  final bool loading;

  const OtpForm({super.key, required this.onVerify, required this.loading});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  // Публичный метод для очистки полей (вызывается извне через key)
  void clearFields() {
    for (var c in _controllers) {
      c.clear();
    }
    // Фокус на первое поле
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _validateCode() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter 4 digits'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    widget.onVerify(code);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (i) {
            return SizedBox(
              height: 64,
              width: 64,
              child: TextFormField(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                onChanged: (v) => _onChanged(v, i),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff363062),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: '•',
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(
                    color: Color(0xFFC5C5C5),
                    fontSize: 22,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 36),

        ElevatedButton(
          onPressed: widget.loading ? null : _validateCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff363062),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: widget.loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Verify Code',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
        ),
      ],
    );
  }
}
