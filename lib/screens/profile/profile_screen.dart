// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:barberly/screens/profile/about.dart';
import 'package:barberly/screens/profile/account_details.dart';
import 'package:barberly/screens/profile/help.dart';
import 'package:barberly/screens/profile/security.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNotificationOn = true;
  void _goToNextPage(title) {
    Widget page = const Security();
    switch (title) {
      case 'Security':
        page = const Security();
        break;
      case 'Account':
        page = const AccountDetails();
        break;
      case 'Help':
        page = const Help();
        break;
      case 'About':
        page = const About();
        break;
    }
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = const Offset(1.0, 0.0);
          final end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final tweenAnimation = animation.drive(tween);

          return SlideTransition(position: tweenAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff363062),
      body: SafeArea(
        child: Column(
          children: [
            // ===== Верхняя часть =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              color: const Color(0xff363062),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar-подобная часть
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/logo.svg',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Barberly',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Блок профиля
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=12',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Joe Samanta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFCA311),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Platinum',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.white70,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Joesamanta@gmail.com',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Daerah Istimewa Yogyakarta',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ===== Нижняя белая часть =====
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xffF9F9FB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Setting',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Notification switch
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: const Text(
                            'Notification',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Switch(
                            value: isNotificationOn,
                            onChanged: (value) {
                              setState(() => isNotificationOn = value);
                            },
                            activeThumbColor: const Color(0xff363062),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Остальные пункты меню
                      _buildSettingTile('Account'),
                      _buildSettingTile('Security'),
                      _buildSettingTile('Help'),
                      _buildSettingTile('About'),

                      const Spacer(),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff363062),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Log out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () => _goToNextPage(title),
      ),
    );
  }
}
