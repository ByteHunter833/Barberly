// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({super.key});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int currentStatusIndex = 0; // 0=Booked, 1=Waiting, 2=On Process, 3=Finished

  final List<String> statusLabels = [
    'Booked',
    'Waiting',
    'On Process',
    'Finished',
  ];
  final List<String> statusIcons = [
    'assets/icons/calendar_filled.svg',
    'assets/icons/timer.svg',
    'assets/icons/scissors.svg',
    'assets/icons/verify_check.svg',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.delayed(const Duration(seconds: 3), _updateStatus);
  }

  void _updateStatus() {
    if (mounted && currentStatusIndex < 3) {
      setState(() {
        currentStatusIndex++;
      });
      Future.delayed(const Duration(seconds: 3), _updateStatus);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xff363062),
        title: const Text(
          'Booking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Row(
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
          ),
        ],
      ),
      body: Column(
        children: [
          // TabBar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Active booking'),
                Tab(text: 'History'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveBooking(context),
                const Center(child: Text('History content')),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A3D8F),
        onPressed: () {
          setState(() {
            currentStatusIndex = (currentStatusIndex + 1) % 4;
          });
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildActiveBooking(BuildContext context) {
    // FINISHED → показываем success экран
    if (currentStatusIndex == 3) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/verified.svg',
              width: 100,
              height: 100,
              color: const Color(0xFF4A3D8F),
            ),
            const SizedBox(height: 20),
            const Text(
              'Service Finished!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4A3D8F),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Column(
          key: ValueKey(currentStatusIndex),
          children: [
            _buildProgressStatus(context),
            const SizedBox(height: 16),
            _buildBarbershopCard(),
            const SizedBox(height: 16),
            _buildInfoSection(
              imagePath: 'assets/icons/calendar_filled.svg',
              title: 'Date & time',
              content: 'Sun, 15 Jan - 08:00 AM',
            ),
            const SizedBox(height: 16),

            // Time estimate только при WAITING
            if (currentStatusIndex == 1)
              _buildInfoSection(
                imagePath: 'assets/icons/timer.svg',
                title: 'Estimated time',
                content: 'Your barber will start in about 5 minutes',
              ),

            // On Process — контейнер
            if (currentStatusIndex == 2)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Your haircut is in process...',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.deepOrange,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Service selected
            _buildServiceSection(),

            const SizedBox(height: 16),

            // Master barber
            _buildMasterBarber(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStatus(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return _buildStatusIcon(
                statusIcons[index],
                index <= currentStatusIndex,
              );
            }),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                height: 3,
                width:
                    MediaQuery.of(context).size.width *
                    ((currentStatusIndex + 1) / 4) *
                    0.85,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return _buildStatusLabel(
                statusLabels[index],
                index == currentStatusIndex,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String path, bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: active ? Colors.orange.withOpacity(0.15) : Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        path,
        color: active ? Colors.orange : Colors.grey[400],
      ),
    );
  }

  Widget _buildStatusLabel(String label, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4A3D8F) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey[600],
          fontSize: 11,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBarbershopCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Master Piece Barbershop',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Jogja Expo Centre (2 km)',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String imagePath,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(imagePath, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/icons/scissors.svg'),
              const SizedBox(width: 8),
              const Text(
                'Service selected',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildServiceItem(
            'Basic haircut',
            'Basic haircut & vitamin',
            'https://images.unsplash.com/photo-1622286342621-4bd786c2447c?w=400',
          ),
          const SizedBox(height: 12),
          _buildServiceItem(
            'Massage',
            'Extra massage',
            'https://images.unsplash.com/photo-1559599101-f09722fb4948?w=400',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String title, String subtitle, String imageUrl) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMasterBarber() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Luther Hammes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                'Specialist Haircut',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
