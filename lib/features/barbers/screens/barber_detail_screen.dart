// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'dart:math';

import 'package:barberly/core/firebase_service/firebase_auth_provider.dart';
import 'package:barberly/core/models/barber.dart';
import 'package:barberly/features/booking/screens/booking_appointment.dart';
import 'package:barberly/features/chat/providers/chat_provider.dart';
import 'package:barberly/features/chat/screens/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

import 'map_screen.dart';


class BarberDetailScreen extends ConsumerStatefulWidget {
  final Barber barber;
  const BarberDetailScreen({super.key, required this.barber});

  @override
  ConsumerState<BarberDetailScreen> createState() => _BarberDetailScreenState();
}

class _BarberDetailScreenState extends ConsumerState<BarberDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Animation<double> _animation;
  bool isFavorite = false;
  int selectedTabIndex = 0;
  bool _isBookingLoading = false;
  bool _isChatLoading = false;
  bool serviceEnabledCtx = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animation = _tabController.animation!;
    selectedTabIndex = _tabController.index;
    _animation.addListener(_onAnimationChanged);
    // Future.microtask(() {
    //   checkLocationService(context);
    // });
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

  Future<void> _navigateToBooking() async {
    if (_isBookingLoading) return;

    setState(() {
      _isBookingLoading = true;
    });

    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingAppointment(barber: widget.barber),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBookingLoading = false;
        });
      }
    }
  }

  Future<void> _openChat() async {
    if (_isChatLoading) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to chat'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isChatLoading = true;
    });

    try {
      final bookingId = 'booking001';
      final chatRoomId = await ref
          .read(chatControllerProvider.notifier)
          .createChatRoom(
            barberPhone: widget.barber.phone,
            barberId: widget.barber.id,
            clientName: user.displayName,
            clientImageUrl: user.photoURL,
            clientId: user.uid,
            bookingId: bookingId,
          );

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MessagesScreen(
              chatRoomId: chatRoomId,
              barberId: widget.barber.id,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open chat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChatLoading = false;
        });
      }
    }
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
                    image: AssetImage('assets/images/recommended.png'),
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
                      Text(
                        widget.barber.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Location
                      if (widget.barber.location != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.barber.distance != null
                                  ? '${widget.barber.location} • ${widget.barber.distance}'
                                  : widget.barber.location!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Location not specified',
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
                          Text(
                            widget.barber.rating.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${double.parse(widget.barber.rating.toString()) >= 0 ? '24' : '0'})',
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
                        mainAxisAlignment: .spaceAround,
                        children: [
                          _buildActionButton(
                            icon: SvgPicture.asset(
                              'assets/icons/google_maps.svg',
                              width: 24,
                              height: 24,
                            ),
                            label: 'Maps',
                            color: const Color(0xFF2C3E7C),
                            onTap: () async {
                              // TODO: Open maps
                              Future.microtask(() {
                                checkLocationService(context);
                              });
                              if(serviceEnabledCtx){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MapScreen(),
                                  ),
                                );
                              }

                            },
                          ),
                          _buildActionButton(
                            icon: _isChatLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF2C3E7C),
                                      ),
                                    ),
                                  )
                                : SvgPicture.asset('assets/icons/chat.svg'),
                            label: 'Chat',
                            color: const Color(0xFF2C3E7C),
                            onTap: _isChatLoading ? null : _openChat,
                          ),
                          _buildActionButton(
                            icon: const Icon(Icons.share_outlined),
                            label: 'Share',
                            color: Colors.grey[700]!,
                            onTap: () {
                              // TODO: Share functionality
                            },
                          ),
                          _buildActionButton(
                            icon: isFavorite
                                ? const Icon(Icons.favorite, color: Colors.pink)
                                : const Icon(Icons.favorite_border),
                            label: 'Favorite',
                            color: Colors.pink,
                            onTap: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
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
                onPressed: _isBookingLoading ? null : _navigateToBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E7C),
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isBookingLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
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
    required Widget icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: icon,
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
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.barber.bio != null && widget.barber.bio!.isNotEmpty)
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
                children: [
                  TextSpan(
                    text: widget.barber.bio!,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        '   Read more...',
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
            )
          else
            Text(
              'No bio available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          const SizedBox(height: 24),
          const Text(
            'Opening Hours',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          _buildHoursRow('Monday - Friday', '09.00 am - 08.00 pm'),
          const SizedBox(height: 10),
          _buildHoursRow('Saturday - Sunday', '09.00 am - 09.00 pm'),
          const SizedBox(height: 24),
          const Text(
            'Contact Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          if (widget.barber.phone != null && widget.barber.phone!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Phone',
              value: widget.barber.phone!,
            ),
          if (widget.barber.email != null && widget.barber.email!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _buildInfoRow(
                icon: Icons.email,
                label: 'Email',
                value: widget.barber.email!,
              ),
            ),
          if ((widget.barber.phone == null || widget.barber.phone!.isEmpty) &&
              (widget.barber.email == null || widget.barber.email!.isEmpty))
            Text(
              'No contact information available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildServiceTab() {
    final services = widget.barber.services ?? [];

    if (services.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.content_cut_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No services available',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service['name'] ?? 'Service',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3E7C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '\$${service['price'] ?? 0}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E7C),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    '${service['durationMinutes'] ?? 0} minutes',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (service['description'] != null &&
                  service['description'].toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  service['description'],
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Working Schedule',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildScheduleCard('Monday', '09:00 AM - 08:00 PM', true),
          _buildScheduleCard('Tuesday', '09:00 AM - 08:00 PM', true),
          _buildScheduleCard('Wednesday', '09:00 AM - 08:00 PM', true),
          _buildScheduleCard('Thursday', '09:00 AM - 08:00 PM', true),
          _buildScheduleCard('Friday', '09:00 AM - 08:00 PM', true),
          _buildScheduleCard('Saturday', '09:00 AM - 09:00 PM', true),
          _buildScheduleCard('Sunday', '09:00 AM - 09:00 PM', true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(String day, String hours, bool isOpen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOpen ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOpen ? Colors.grey[300]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isOpen ? Colors.black87 : Colors.grey[600],
            ),
          ),
          Row(
            children: [
              Text(
                hours,
                style: TextStyle(
                  fontSize: 14,
                  color: isOpen ? Colors.black87 : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOpen
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isOpen ? 'Open' : 'Closed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOpen ? const Color(0xFF4CAF50) : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2C3E7C)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }



  Future<void> checkLocationService(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      serviceEnabledCtx = serviceEnabled;
    });

    if (!serviceEnabled) {
      // GPS o‘chik — dialog chiqaramiz
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Location o‘chirilgan"),
          content: Text("Iltimos, joylashuv (GPS) ni yoqing."),
          actions: [
            TextButton(
              child: Text("Bekor qilish"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Location yoqish"),
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
            ),
          ],
        ),
      );
    }
  }

}
