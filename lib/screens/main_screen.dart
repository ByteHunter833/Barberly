import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gobar/screens/chat/chat_screen.dart';
import 'package:gobar/screens/home_page.dart';
import 'package:gobar/screens/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const HomePage(),
    const Center(child: Text('Booking', style: TextStyle(fontSize: 18))),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  final List<String> _icons = [
    'assets/icons/home.svg',
    'assets/icons/calendar_filled.svg',
    'assets/icons/chat.svg',
    'assets/icons/account.svg',
  ];

  final List<String> _labels = ['Home', 'Booking', 'Chat', 'Account'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 13,
        unselectedFontSize: 12,
        items: List.generate(_icons.length, (index) {
          final isSelected = _selectedIndex == index;
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _icons[index],
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.blueAccent : Colors.grey,
                BlendMode.srcIn,
              ),
              height: 24,
              width: 24,
            ),
            label: _labels[index],
          );
        }),
      ),
    );
  }
}
