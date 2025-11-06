import 'package:barberly/screens/barbers/explore_barbers.dart';
import 'package:flutter/material.dart';

class BannerHome extends StatelessWidget {
  const BannerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      width: double.infinity,
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
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ExploreBarbers(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          final begin = const Offset(1.0, 0.0);
                          final end = Offset.zero;
                          final tween = Tween(begin: begin, end: end);
                          final tweenAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: tweenAnimation,
                            child: child,
                          );
                        },
                  ),
                );
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
