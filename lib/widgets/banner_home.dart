import 'package:flutter/material.dart';
import 'package:gobar/service/localstorage_service.dart';

class BannerHome extends StatelessWidget {
  const BannerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      width: 366,
      decoration: BoxDecoration(
        color: const Color(0xffF99417),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/surface.png', fit: BoxFit.cover),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset('assets/images/banner_image.png'),
          ),
          Positioned(
            left: 12,
            top: 12,
            child: Image.asset('assets/images/banner_logo.png'),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: ElevatedButton(
              onPressed: () async {
                final user = await LocalStorage.getUserName();
                print(user);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff363062),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Booking Now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
