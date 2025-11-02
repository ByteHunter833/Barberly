// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:barberly/screens/booking/booking_appointment.dart';

class BarberDetailScreen extends StatefulWidget {
  const BarberDetailScreen({super.key});

  @override
  _BarberDetailScreenState createState() => _BarberDetailScreenState();
}

class _BarberDetailScreenState extends State<BarberDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Animation<double> _animation;
  bool isFavorite = false;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animation = _tabController.animation!;
    selectedTabIndex = _tabController.index;
    _animation.addListener(_onAnimationChanged);
  }

  void _onAnimationChanged() {
    final newIndex = _animation.value.round();
    if (selectedTabIndex != newIndex) {
      setState(() {
        selectedTabIndex = newIndex;
      });
    }
  }

  @override
  void dispose() {
    _animation.removeListener(_onAnimationChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Image with Back Button and Open Badge
          Stack(
            children: [
              Container(
                height: 240,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=300&fit=crop',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 44,
                left: 16,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Open',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Master piece Barbershop - Haircut styling',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Joga Expo Centre (2 km)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          const Text(
                            '5.0',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(24)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(
                            icon: Icons.map_outlined,
                            label: 'Maps',
                            color: Colors.blue,
                          ),
                          _buildActionButton(
                            icon: Icons.chat_bubble_outline,
                            label: 'Chat',
                            color: const Color(0xFF2C3E7C),
                          ),
                          _buildActionButton(
                            icon: Icons.share_outlined,
                            label: 'Share',
                            color: Colors.grey[700]!,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            child: _buildActionButton(
                              icon: isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              label: 'Favorite',
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Custom Tab Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildCustomTab(
                        icon: Icons.groups_outlined,
                        label: 'About',
                        index: 0,
                      ),
                      const SizedBox(width: 12),
                      _buildCustomTab(
                        icon: Icons.content_cut_outlined,
                        label: 'Service',
                        index: 1,
                      ),
                      const SizedBox(width: 12),
                      _buildCustomTab(
                        icon: Icons.calendar_today_outlined,
                        label: 'Schedule',
                        index: 2,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Tab Bar View Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAboutTab(),
                      _buildServiceTab(),
                      _buildScheduleTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingAppointment(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E7C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Booking Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTab({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Immediate color change on tap
          setState(() {
            selectedTabIndex = index;
          });
          _tabController.animateTo(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2C3E7C) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF2C3E7C) : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.6,
              ),
              children: [
                const TextSpan(
                  text:
                      'At Masterpiece Barbershop, our dedicated team of skilled barbers are true artists in their craft, transforming your hair, ',
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Read more...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2C3E7C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Opening Hours
          const Text(
            'Opening Hours',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          _buildHoursRow('Monday - friday', '09.00 am - 08.00 pm'),
          const SizedBox(height: 10),
          _buildHoursRow('Saturday - Sunday', '09.00 am - 09.00 pm'),
          const SizedBox(height: 24),

          // Our Tim
          const Text(
            'Our Tim',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          _buildBarberCard(
            name: 'Luther Hammes',
            specialty: 'Specialist Haircut',
            rating: 5.0,
            image:
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
          ),
          const SizedBox(height: 12),
          _buildBarberCard(
            name: 'Emanuel Bernier',
            specialty: 'Specialist Coloring',
            rating: 4.5,
            image:
                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop',
          ),
          const SizedBox(height: 12),
          _buildBarberCard(
            name: 'Karl Vandervort',
            specialty: 'Specialist Treatment',
            rating: 4.5,
            image:
                'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildServiceTab() {
    return const Center(
      child: Text(
        'Service Tab Content',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return const Center(
      child: Text(
        'Schedule Tab Content',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildHoursRow(String days, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(days, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        Text(
          hours,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBarberCard({
    required String name,
    required String specialty,
    required double rating,
    required String image,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 26, backgroundImage: NetworkImage(image)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
