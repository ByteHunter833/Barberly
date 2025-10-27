// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gobar/provider/api_service_provider.dart';
import 'package:gobar/service/localstorage_service.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final phone = args?['otp']['phone'] ?? '';
    final code = args?['otp']['code'] ?? '';

    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.status.whenOrNull(
        data: (data) async {
          final user = data['user']['name'];
          await LocalStorage.saveToken(data['token']);
          await LocalStorage.saveUsername(user);
          Navigator.pushReplacementNamed(context, '/main');
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
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
                  'We sent a code to $phone, code $code',
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                OtpForm(
                  onVerify: (code) {
                    ref
                        .read(authControllerProvider.notifier)
                        .verifyOtp(phone, code);
                  },
                  loading: authState.status.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//message, token, user
class OtpForm extends StatefulWidget {
  final void Function(String code) onVerify;
  final bool loading;

  const OtpForm({super.key, required this.onVerify, required this.loading});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

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
    }
    if (value.isEmpty && index > 0) {
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
    return Form(
      key: _formKey,
      child: Column(
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
                ? const CircularProgressIndicator()
                : const Text(
                    'Verify Code',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
          ),
        ],
      ),
    );
  }
}
