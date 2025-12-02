import 'package:barberly/core/widgets/banner_home.dart';
import 'package:barberly/core/widgets/barber_card.dart';
import 'package:barberly/core/widgets/filter_bottom_sheet.dart';
import 'package:barberly/features/barbers/providers/barbers_provider.dart';
import 'package:barberly/features/barbers/providers/current_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends ConsumerStatefulWidget {
  final String user;
  const HomePage({super.key, required this.user});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool serviceEnabledCtx = false;
  bool permissionGranted = false;

  @override
  void initState() {
    super.initState();
    initLocationFlow();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  /// Основной flow для локации
  Future<void> initLocationFlow() async {
    await requestLocationPermission();
    await checkLocationService(context);

    if (serviceEnabledCtx && permissionGranted) {
      Future.microtask(
        () => ref.read(barbersControllerProvider.notifier).fetchNearestBarber(),
      );
    }
  }

  /// Запрашивает permission
  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      permissionGranted = false;
      await Geolocator.openAppSettings();
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      permissionGranted = true;
    }
  }

  /// Проверка GPS
  Future<void> checkLocationService(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      serviceEnabledCtx = serviceEnabled;
    });

    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location выключен'),
          content: const Text('Пожалуйста, включите GPS.'),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Включить GPS'),
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
                await checkLocationService(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> printLocationFromProvider() async {
    try {
      Position position = await CurrentLocationProvider.determinePosition();
      print('🌍 Current location:');
      print('Latitude: ${position.latitude}');
      print('Longitude: ${position.longitude}');
      print('Timestamp: ${position.timestamp}');
    } catch (e) {
      print('Ошибка при получении локации: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barbersState = ref.watch(barbersControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (serviceEnabledCtx && permissionGranted) {
              await ref
                  .read(barbersControllerProvider.notifier)
                  .fetchNearestBarber();
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            physics: const AlwaysScrollableScrollPhysics(),
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
                if (!serviceEnabledCtx || !permissionGranted)
                  const Center(child: CircularProgressIndicator())
                else
                  barbersState.status.when(
                    data: (_) {
                      // Безопасно приводим к List<NearestBarber> — если нет, то пустой список
                      final rawList = barbersState.nearestTenants;

                      final filteredRaw = _searchQuery.isEmpty
                          ? rawList
                          : rawList.where((barber) {
                              final name = barber.name.toLowerCase();
                              return name.contains(_searchQuery);
                            }).toList();

                      if (filteredRaw.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  _searchQuery.isEmpty
                                      ? LucideIcons.users
                                      : LucideIcons.searchX,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'No barbers available'
                                      : 'No barbers found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try searching with different keywords',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }

                      return _mostRecommendSection(context, filteredRaw);
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, st) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.alertCircle,
                              size: 64,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Failed to load barbers',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              e.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (serviceEnabledCtx && permissionGranted) {
                                  ref
                                      .read(barbersControllerProvider.notifier)
                                      .fetchNearestBarber();
                                }
                              },
                              icon: const Icon(LucideIcons.refreshCw),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff363062),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xff363062),
                      side: const BorderSide(color: Color(0xff363062)),
                    ),
                    onPressed: () => {},
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
              widget.user.isNotEmpty ? widget.user : 'Guest',
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
          backgroundColor: const Color(0xff363062),
          child: Text(
            widget.user.isNotEmpty
                ? widget.user.substring(0, 1).toUpperCase()
                : 'G',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
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
            controller: _searchController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xffEBF0F5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xff363062),
                  width: 2,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset('assets/icons/search.svg'),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              hintText: "Search barber's, haircut service",
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
    // barbers — список Map<String, dynamic>, готовый к передаче в BarberCard
    return Column(
      children: List.generate(barbers.length, (index) {
        final barber = barbers[index];
        return BarberCard(barber: barber);
      }),
    );
  }
}
