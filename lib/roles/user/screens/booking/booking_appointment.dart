// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:barberly/roles/user/screens/booking/your_appointment_screen.dart';
import 'package:barberly/roles/user/widgets/data_picker.dart';

class BookingAppointment extends StatefulWidget {
  const BookingAppointment({super.key});

  @override
  State<BookingAppointment> createState() => _BookingAppointmentState();
}

class _BookingAppointmentState extends State<BookingAppointment> {
  int? selectedServiceIndex;
  int? selectedTimeIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Book Appointment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),

            const Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 18),
            const ModernDatePicker(),

            const SizedBox(height: 18),
            const Text(
              'Choose Service',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 18),
            _services(),
            const SizedBox(height: 18),

            const Text(
              'Available time',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 18),
            _availableTime(),

            const SizedBox(height: 24),
            const Text(
              'Payment summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 18),
            _paymentSummary(),

            const SizedBox(height: 24),
            _dealBookingButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _services() {
    final List<Map<String, String>> services = [
      {
        'imagePath': 'assets/images/basic_haircut.png',
        'label': 'Basic haircut',
        'price': '\$20',
      },
      {
        'imagePath': 'assets/images/kids_haircut.png',
        'label': 'Kids haircut',
        'price': '\$15',
      },
      {
        'imagePath': 'assets/images/hair_coloring.png',
        'label': 'Hair coloring',
        'price': '\$30',
      },
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final service = services[index];
          final bool isSelected = selectedServiceIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedServiceIndex = index;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(service['imagePath']!),
                    ),

                    if (isSelected)
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  service['label']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  service['price']!,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _availableTime() {
    final List<Map<String, dynamic>> timeSlots = [
      {'time': '08:00', 'isAvailable': true},
      {'time': '08:30', 'isAvailable': true},
      {'time': '09:00', 'isAvailable': false},
      {'time': '09:30', 'isAvailable': true},
      {'time': '10:00', 'isAvailable': true},
      {'time': '10:30', 'isAvailable': true},
      {'time': '11:30', 'isAvailable': true},
      {'time': '13:00', 'isAvailable': true},
      {'time': '15:30', 'isAvailable': true},
      {'time': '16:00', 'isAvailable': false},
      {'time': '17:00', 'isAvailable': true},
      {'time': '17:30', 'isAvailable': true},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        final isSelected = selectedTimeIndex == index;
        final isAvailable = slot['isAvailable'] as bool;

        return GestureDetector(
          onTap: isAvailable
              ? () {
                  setState(() {
                    selectedTimeIndex = index;
                  });
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF3D3080) : Colors.white,
              border: Border.all(
                color: isAvailable
                    ? (isSelected
                          ? const Color(0xFF3D3080)
                          : Colors.grey.shade300)
                    : Colors.grey.shade200,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              slot['time'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isAvailable
                    ? (isSelected ? Colors.white : Colors.black)
                    : Colors.grey.shade400,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _paymentSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _summaryRow('Basic haircut', '\$20'),
          const SizedBox(height: 12),
          _summaryRow('Extra massage', '\$10'),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _summaryRow('Service fee', '\$25', isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String price, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _dealBookingButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const YourAppointmentScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3D3080),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Deal booking',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset('assets/icons/calendar.svg'),
          ],
        ),
      ),
    );
  }
}
