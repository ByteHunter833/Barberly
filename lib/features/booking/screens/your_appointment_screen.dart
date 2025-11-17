// ignore_for_file: deprecated_member_use

import 'package:barberly/core/network/api_service.dart';
import 'package:barberly/features/booking/repositories/booking_repository.dart';
import 'package:barberly/features/booking/screens/booking_succes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class YourAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic>? bookingData;

  const YourAppointmentScreen({super.key, this.bookingData});

  @override
  State<YourAppointmentScreen> createState() => _YourAppointmentScreenState();
}

class _YourAppointmentScreenState extends State<YourAppointmentScreen> {
  final TextEditingController _couponController = TextEditingController();
  bool isCouponApplied = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barber = widget.bookingData?['barber'];
    final services = widget.bookingData?['services'] as List<dynamic>? ?? [];
    final date = widget.bookingData?['date'] ?? '';
    final time = widget.bookingData?['time'] ?? '';

    double totalPrice = 0;
    for (var service in services) {
      totalPrice += double.tryParse(service['price']?.toString() ?? '0') ?? 0;
    }

    double discount = isCouponApplied ? totalPrice * 0.1 : 0;
    double finalPrice = totalPrice - discount;

    return Scaffold(
      backgroundColor: const Color(0xff363062),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff363062),
        title: const Text('Your Appointment'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/profile_surface.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade300,
                      child: barber?.imageUrl != null
                          ? Image.network(
                              barber.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/recommended1.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/recommended1.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barber?.name ?? 'Barber',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                barber?.location ?? 'Location not available',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              barber?.rating?.toString() ?? '0.0',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/calendar_filled.svg',
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Date & time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$date - $time',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/scissors.svg'),
                        const SizedBox(width: 8),
                        const Text(
                          'Service list',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    ...services.asMap().entries.map((entry) {
                      final service = entry.value;
                      final isLast = entry.key == services.length - 1;
                      return Column(
                        children: [
                          _buildServiceItem(
                            image: 'assets/images/basic_haircut.png',
                            title: service['name'] ?? 'Service',
                            subtitle: service['description'] ?? 'Service',
                            price: '\$${service['price']}',
                          ),
                          if (!isLast) const SizedBox(height: 16),
                        ],
                      );
                    }),

                    const SizedBox(height: 24),

                    const Text(
                      'Apply Coupon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _couponController,
                            decoration: InputDecoration(
                              hintText: 'DISC20PERCEN',
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset(
                                  'assets/icons/discount.svg',
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isCouponApplied = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D3080),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Apply'),
                        ),
                      ],
                    ),

                    if (isCouponApplied)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Coupon applied successfully!',
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ),

                    const SizedBox(height: 24),

                    const Text(
                      'Payment summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ...services.asMap().entries.map((entry) {
                      final service = entry.value;
                      return Column(
                        children: [
                          _buildSummaryRow(
                            service['name'] ?? 'Service',
                            '\$${service['price']}',
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }),

                    if (isCouponApplied)
                      _buildSummaryRow(
                        'Coupon discount (10%)',
                        '- \$${discount.toStringAsFixed(2)}',
                        valueColor: Colors.green,
                      ),

                    const SizedBox(height: 16),
                    const Divider(),

                    const SizedBox(height: 16),

                    _buildSummaryRow(
                      'Total price',
                      '\$${finalPrice.toStringAsFixed(2)}',
                      isTotal: true,
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handlePayNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D3080),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Pay now',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SvgPicture.asset('assets/icons/wallet.svg'),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePayNow() async {
    if (widget.bookingData == null) return;

    final barberId = widget.bookingData?['barberId']?.toString();
    final tenantId = widget.bookingData?['tenantId'];
    final serviceIds = widget.bookingData?['serviceIds'] as List<dynamic>?;
    final dateTime = widget.bookingData?['dateTime']?.toString();

    if (barberId == null ||
        tenantId == null ||
        serviceIds == null ||
        dateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing booking information')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final api = ApiService();
      await api.loadToken();
      final repository = BookingRepository(api);

      final result = await repository.createOrder(
        barberId: barberId,
        tenantId: tenantId,
        serviceIds: serviceIds.map((e) => e.toString()).toList(),
        dateTime: dateTime,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BookingSuccessScreen(),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(result['message'] ?? 'Failed to create order')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildServiceItem({
    required String image,
    required String title,
    required String subtitle,
    required String price,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
        Text(
          price,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
