import 'package:flutter/material.dart';

class BarberList extends StatelessWidget {
  const BarberList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _barbers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        final item = _barbers[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.asset(
                  item['imagePath'],
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
                        item['title'],
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
                            item['location'],
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
                            item['rating'].toString(), // ✅ Исправлено
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
        );
      },
    );
  }
}

final List<Map<String, dynamic>> _barbers = [
  {
    'title': 'Alana Barbershop - Haircut massage & Spa',
    'rating': 4.0,
    'location': 'Banguntapan (5 km)',
    'imagePath': 'assets/images/nearbarber1.png',
  },
  {
    'title': 'Hercha Barbershop - Haircut & Styling',
    'rating': 5.0,
    'location': 'Banguntapan (5 km)',
    'imagePath': 'assets/images/nearbarber2.png',
  },
  {
    'title': 'Barberking - Haircut styling & massage',
    'rating': 4.5,
    'location': 'Jogja Expo Centre (12 km)',
    'imagePath': 'assets/images/nearbarber3.png',
  },
];
