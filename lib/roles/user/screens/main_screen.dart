import 'package:barberly/roles/user/screens/booking/booking_screen.dart';
import 'package:barberly/roles/user/screens/chat/chat_screen.dart';
import 'package:barberly/roles/user/screens/home/home_page.dart';
import 'package:barberly/roles/user/screens/profile/profile_screen.dart';
import 'package:barberly/services/localstorage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final user = await LocalStorage.getUserName();
    setState(() {
      _username = user;
    });
  }

  void _onItemTapped(int index) {
    // final user = await LocalStorage.getUserName();
    // print(user);

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
    final screens = [
      HomePage(user: _username ?? ''), // передаем уже готовую строку
      const BookingDetailScreen(),
      const ChatScreen(),
      ProfileScreen(user: _username ?? ''),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: List.generate(_icons.length, (index) {
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _icons[index],
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == index ? Colors.blueAccent : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: _labels[index],
          );
        }),
      ),
    );
  }
}
