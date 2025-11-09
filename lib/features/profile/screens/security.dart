import 'package:flutter/material.dart';
import 'package:barberly/core/widgets/my_textfield.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool isOldPasswordVisible = true;
  bool isNewPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Security',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff363062),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 12),

            MyTextfield(
              obscureText: isOldPasswordVisible,
              hintText: 'Enter your password',
              labelText: 'Current Password',
              prefixIcon: const Icon(
                Icons.key_outlined,
                color: Color(0xff363062),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => isOldPasswordVisible = !isOldPasswordVisible);
                },
                icon: Icon(
                  isOldPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
            const SizedBox(height: 12),

            MyTextfield(
              obscureText: isNewPasswordVisible,
              hintText: 'Enter new password',
              labelText: 'New Password',
              prefixIcon: const Icon(
                Icons.key_outlined,
                color: Color(0xff363062),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => isNewPasswordVisible = !isNewPasswordVisible);
                },
                icon: Icon(
                  isNewPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xff363062),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
