import 'package:barberly/features/barbers/providers/barbers_provider.dart';
import 'package:barberly/features/barbers/screens/barber_detail_screen.dart';
import 'package:barberly/core/widgets/banner_home.dart';
import 'package:barberly/core/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends ConsumerStatefulWidget {
  final String user;
  const HomePage({super.key, required this.user});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Загружаем барберов при старте
    Future.microtask(
      () => ref.read(barbersControllerProvider.notifier).loadBarbers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final barbersState = ref.watch(barbersControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 24),
              const BannerHome(),
              const SizedBox(height: 24),
              _searchBar(context),
              const SizedBox(height: 24),
              const Text(
                'Most recommended',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              barbersState.status.when(
                data: (barbers) =>
                    _mostRecommendSection(context, barbersState.barbers),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) {
                  print('error loading barbers: $e');
                  return const Center(child: Text('Ошибка загрузки'));
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff363062),
                    side: const BorderSide(color: Color(0xff363062)),
                  ),
                  onPressed: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xff363062),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(LucideIcons.arrowUpRightSquare),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(LucideIcons.mapPin, size: 16, color: Color(0xff363062)),
                SizedBox(width: 4),
                Text(
                  'Yogyakarta',
                  style: TextStyle(fontSize: 14, color: Color(0xff363062)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              widget.user,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xff1C1C1C),
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey,
          child: Text(
            widget.user.isNotEmpty ? widget.user.substring(0, 1) : '',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _searchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xffEBF0F5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset('assets/icons/search.svg'),
              ),
              hintText: 'Search barber’s, haircut service',
              hintStyle: const TextStyle(color: Color(0xff8683A1)),
              filled: true,
              fillColor: const Color(0xffEBF0F5),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => FilterBottomSheet.show(context),
          style: IconButton.styleFrom(
            minimumSize: const Size(53, 53),
            backgroundColor: const Color(0xff363062),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: SvgPicture.asset(
            'assets/icons/filter.svg',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  Widget _mostRecommendSection(BuildContext context, List barbers) {
    return Column(
      children: List.generate(barbers.length, (index) {
        final barber = barbers[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarberDetailScreen(barber: barber),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.network(
                    barber.imageUrl ?? '',
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/nearbarber2.png');
                    },
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
                          barber.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1C1C1C),
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (barber.location != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xff363062),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                barber.location! + ' • ' + barber.distance!,
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
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              barber.rating.toString(),
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
          ),
        );
      }),
    );
  }
}
