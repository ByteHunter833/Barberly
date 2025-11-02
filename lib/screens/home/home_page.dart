import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:barberly/screens/barbers/barber_detail_screen.dart';
import 'package:barberly/screens/barbers/explore_barbers.dart';
import 'package:barberly/widgets/banner_home.dart';
import 'package:barberly/widgets/filter_bottom_sheet.dart';
import 'package:lucide_icons/lucide_icons.dart'; // ⚡️ Удобная иконка для локации

class HomePage extends StatefulWidget {
  final String user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            LucideIcons.mapPin,
                            size: 16,
                            color: Color(0xff363062),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Yogyakarta',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff363062),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.user,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1C1C1C),
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                    child: Text(
                      widget.user.isNotEmpty ? widget.user.substring(0, 1) : '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const BannerHome(),
              const SizedBox(height: 24),
              _searchBar(context),

              // _nearestBarberShop(),
              const SizedBox(height: 24),
              const Text(
                'Most recommended',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              _mostRecommend(),
              const SizedBox(height: 24),

              _mostRecommendSection(context),
              const SizedBox(height: 16),

              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff363062),
                    side: const BorderSide(color: Color(0xff363062)),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExploreBarbers(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xff363062),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(LucideIcons.arrowUpRightSquare),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _searchBar(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffEBF0F5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blueAccent),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset('assets/icons/search.svg'),
            ),
            hintText: 'Search barber’s, haircut service',
            hintStyle: const TextStyle(color: Color(0xff8683A1)),
            filled: true,
            fillColor: const Color(0xffEBF0F5),
          ),
        ),
      ),
      const SizedBox(width: 8),
      IconButton(
        onPressed: () => FilterBottomSheet.show(context),
        style: IconButton.styleFrom(
          minimumSize: const Size(53, 53),
          backgroundColor: const Color(0xff363062),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: SvgPicture.asset(
          'assets/icons/filter.svg',
          width: 24,
          height: 24,
        ),
      ),
    ],
  );
}

Widget _mostRecommend() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 216,
        child: Stack(
          children: [
            Image.asset('assets/images/recommended.png'),
            Positioned(
              bottom: -5,
              right: -2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff363062),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Booking'),
                    const SizedBox(width: 10),
                    SvgPicture.asset('assets/icons/calendar.svg'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Master piece Barbershop - Haircut styling',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 10),

      const Row(
        children: [
          Icon(Icons.location_on, color: Color(0xff363062), size: 16),
          SizedBox(width: 4),
          Text(
            'Joga Expo Centre  (2 km)',
            style: TextStyle(fontSize: 12, color: Color(0xff6B7280)),
          ),
        ],
      ),
      const SizedBox(height: 6),
      const Row(
        children: [
          Icon(Icons.star, color: Colors.amber, size: 16),
          SizedBox(width: 4),
          Text(
            '5.0', // ✅ Исправлено
            style: TextStyle(fontSize: 12, color: Color(0xff6B7280)),
          ),
        ],
      ),
    ],
  );
}

Widget _mostRecommendSection(BuildContext context) {
  final List<Map<String, dynamic>> barbers = [
    {
      'title': 'Varcity Barbershop Jogja  ex The Varcher',
      'rating': 4.5,
      'location': 'Condongcatur (10 km)',
      'imagePath': 'assets/images/recommended1.png',
    },
    {
      'title': 'Twinsky Monkey Barber & Men Stuff',
      'rating': 5.0,
      'location': 'Jl Taman Siswa (8 km)',
      'imagePath': 'assets/images/recommended2.png',
    },
    {
      'title': 'Barberman - Haircut styling & massage',
      'rating': 4.5,
      'location': 'J-Walk Centre  (17 km)',
      'imagePath': 'assets/images/recommended3.png',
    },
  ];

  return Column(
    children: List.generate(barbers.length, (index) {
      final barber = barbers[index];

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BarberDetailScreen()),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.asset(
                  barber['imagePath'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barber['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1C1C1C),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xff363062),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            barber['location'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            barber['rating'].toString(), // ✅ Исправлено
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }),
  );
}
