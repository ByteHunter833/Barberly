import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberly/providers/api_service_provider.dart';
import 'package:barberly/roles/user/widgets/my_textfield.dart';
import 'package:phone_input/phone_input_package.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final void Function()? onTap;
  const SignUpScreen({super.key, this.onTap});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool isObsCured = true;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _phoneController = PhoneController(
    const PhoneNumber(isoCode: IsoCode.UZ, nsn: ''),
  );

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Name is required';
    if (name.length < 3) return 'Name too short';
    return null;
  }

  String? _validatePassword(String? value) {
    final pass = value?.trim() ?? '';
    if (pass.isEmpty) return 'Password is required';
    if (pass.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value != _passwordController.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      final rawPhone = _phoneController.value!.international;
      final phone = rawPhone.replaceAll(RegExp(r'\s+'), '');
      debugPrint(rawPhone);

      ref
          .read(authControllerProvider.notifier)
          .register(
            _nameController.text.trim(),
            phone,
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.status.whenOrNull(
        data: (data) {
          final otp = data;
          Navigator.pushNamed(
            context,
            '/otp',
            arguments: {'otp': otp},
          ); // ✅ успешная регистрация
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
          debugPrint(error.toString());
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36),
                const Text(
                  'Register here ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff363062),
                  ),
                ),
                const Text(
                  'Please enter your data to complete your account registration process',
                  style: TextStyle(color: Color(0xff6B7280), fontSize: 16),
                ),
                const SizedBox(height: 24),

                MyTextfield(
                  hintText: 'Joe Samanta',
                  labelText: 'Name',
                  validator: _validateName,
                  controller: _nameController,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Phone Number',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                PhoneInput(
                  controller: _phoneController,
                  defaultCountry: IsoCode.UZ,
                  countrySelectorNavigator:
                      const CountrySelectorNavigator.modalBottomSheet(),
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
                ),

                const SizedBox(height: 10),

                MyTextfield(
                  obscureText: isObsCured,
                  hintText: '*****',
                  labelText: 'Create password',
                  controller: _passwordController,
                  validator: _validatePassword,
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => isObsCured = !isObsCured);
                    },
                    icon: Icon(
                      isObsCured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                MyTextfield(
                  obscureText: isObsCured,
                  hintText: '*****',
                  labelText: 'Confirm password',
                  controller: _confirmController,
                  validator: _validateConfirm,
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => isObsCured = !isObsCured);
                    },
                    icon: Icon(
                      isObsCured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

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
                    onPressed: authState.status.isLoading ? null : register,

                    child: authState.status.isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Register',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),

                const SizedBox(height: 36),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Color(0xff363062),
                        fontWeight: FontWeight.w500,
                      ),
                      text: 'Already have an account?',
                      children: [
                        TextSpan(
                          text: ' Login',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onTap,
                        ),
                      ],
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
