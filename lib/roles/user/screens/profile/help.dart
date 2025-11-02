import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:barberly/roles/user/widgets/my_textfield.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xff363062)),
        ),
        title: const Text(
          'Help',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff363062),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    SvgPicture.asset(
                      'assets/icons/help.svg',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'How we can help\nyou today?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff363062),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please enter your personal data and\n'
                      'describe your care needs or something\n'
                      'we can help you with',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xff8683A1), fontSize: 14),
                    ),
                    const SizedBox(height: 32),

                    const MyTextfield(
                      prefixIcon: Icon(Icons.person, color: Color(0xff363062)),
                      hintText: 'Joe Samanta',
                      labelText: 'Name',
                    ),
                    const SizedBox(height: 16),
                    const MyTextfield(
                      prefixIcon: Icon(Icons.email, color: Color(0xff363062)),
                      hintText: 'Joesamanta@gmail.com',
                      labelText: 'Email',
                    ),
                    const SizedBox(height: 16),
                    const MyTextfield(
                      labelText: 'Describe',
                      hintText: 'Enter a description here',
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      minLines: 6,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xff363062),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Send',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
