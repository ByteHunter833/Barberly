import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  const BookingSuccessScreen({super.key, this.bookingData});

  @override
  Widget build(BuildContext context) {
    final barber = bookingData?['barber'];
    final services = bookingData?['services'] as List<dynamic>? ?? [];
    final date = bookingData?['date'] ?? '';
    final time = bookingData?['time'] ?? '';

    double totalPrice = 0;
    for (var service in services) {
      totalPrice += double.tryParse(service['price']?.toString() ?? '0') ?? 0;
    }

    String servicesText = services.map((s) => s['name'] ?? '').join(', ');
    if (servicesText.isEmpty) servicesText = 'No services';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff363062),
        foregroundColor: Colors.white,
        title: const Text(
          'Invoice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color(0xff363062),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/profile_surface.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SvgPicture.asset('assets/icons/verified.svg'),
                const SizedBox(height: 12),
                const Text(
                  'Booking Successfully',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Immediately check the booking menu\nfor detailed information',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          // ✅ Исправленный Positioned
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Barbershop info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            barber.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          date + '-' + time,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    // Text(
                    //   'Basic haircut, Massage',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.grey.shade600,
                    //   ),
                    // ),
                    ...services.asMap().entries.map((entry) {
                      final service = entry.value;
                      final isLast = entry.key == services.length - 1;
                      return Row(
                        children: [
                          Text(
                            service['name'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (!isLast) const SizedBox(width: 8),
                        ],
                      );
                    }),

                    const SizedBox(height: 12),

                    // Payment summary
                    const Text(
                      'Payment summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...services.asMap().entries.map((entry) {
                      final service = entry.value;
                      final isLast = entry.key == services.length - 1;
                      return Column(
                        children: [
                          _buildSummaryRow(
                            service['name'],
                            '\$${service['price']}',
                          ),
                          if (!isLast) const SizedBox(height: 16),
                        ],
                      );
                    }),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    _buildSummaryRow(
                      'Total price',
                      '$totalPrice',
                      isTotal: true,
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       flex: 2,
                    //       child: SizedBox(
                    //         height: 54,
                    //         child: ElevatedButton(
                    //           onPressed: () => Navigator.pop(context),
                    //           style: ElevatedButton.styleFrom(
                    //             backgroundColor: const Color(0xFF3D3080),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(12),
                    //             ),
                    //           ),
                    //           child: const Text(
                    //             'Back',
                    //             style: TextStyle(
                    //               fontSize: 16,
                    //               fontWeight: FontWeight.w600,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 12),
                    //     Expanded(
                    //       flex: 3,
                    //       child: SizedBox(
                    //         height: 54,
                    //         child: OutlinedButton(
                    //           onPressed: () {},
                    //           style: OutlinedButton.styleFrom(
                    //             side: const BorderSide(
                    //               color: Color(0xFF3D3080),
                    //               width: 2,
                    //             ),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(12),
                    //             ),
                    //           ),
                    //           child: const Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text(
                    //                 'Download',
                    //                 style: TextStyle(
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w600,
                    //                   color: Color(0xFF3D3080),
                    //                 ),
                    //               ),
                    //               SizedBox(width: 8),
                    //               Icon(
                    //                 Icons.cloud_download_outlined,
                    //                 color: Color(0xFF3D3080),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 54,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/main',
                          (Route<dynamic> route) => false,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D3080),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSummaryRow(
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
