import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FilterBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _FilterContent(),
    );
  }
}

class _FilterContent extends StatefulWidget {
  const _FilterContent();

  @override
  State<_FilterContent> createState() => _FilterContentState();
}

class _FilterContentState extends State<_FilterContent> {
  final List<String> categories = [
    'Basic haircut',
    'Coloring',
    'Treatment',
    'Massage',
    'Kids haircut',
  ];

  String selectedCategory = 'Basic haircut';
  double rating = 4.0;
  double minDistance = 0.1;
  double maxDistance = 10.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.help_outline, color: Color(0xff363062)),
                  SizedBox(width: 6),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1C1C1C),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Color(0xff9C9D9E)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Categories
          const Text(
            'General Category',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff1C1C1C),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final isSelected = cat == selectedCategory;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: const Color(0xffE4E3F6),
                backgroundColor: const Color(0xffF3F4F6),
                labelStyle: TextStyle(
                  color: isSelected
                      ? const Color(0xff363062)
                      : const Color(0xff6B7280),
                  fontWeight: FontWeight.w500,
                ),
                onSelected: (_) => setState(() => selectedCategory = cat),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Rating
          const Text(
            'Rating Barber',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff1C1C1C),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 28,
                unratedColor: Colors.grey[300],
                itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (r) => setState(() => rating = r),
              ),
              const SizedBox(width: 8),
              Text(
                '(${rating.toStringAsFixed(1)})',
                style: const TextStyle(color: Color(0xff6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Distance
          const Text(
            'Distance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff1C1C1C),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _distanceBox('${minDistance.toStringAsFixed(1)} km', 'Nearest'),
              const SizedBox(width: 8),
              const Text('-', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              _distanceBox('${maxDistance.toStringAsFixed(0)} km', 'Farthest'),
            ],
          ),
          const SizedBox(height: 20),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff363062),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _distanceBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffD1D5DB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xff1C1C1C),
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xff6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}
