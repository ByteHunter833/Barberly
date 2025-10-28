import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gobar/widgets/filter_bottom_sheet.dart';

class ExploreBarbers extends StatelessWidget {
  const ExploreBarbers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 24),
            _searchBar(context),
          ],
        ),
      ),
    );
  }
}

Widget _header() {
  return Column(
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
