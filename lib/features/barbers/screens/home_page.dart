import 'package:barberly/core/widgets/banner_home.dart';
import 'package:barberly/core/widgets/barber_card.dart';
import 'package:barberly/core/widgets/filter_bottom_sheet.dart';
import 'package:barberly/features/barbers/providers/barbers_provider.dart';
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
  bool _isInitializing = true;

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
    setState(() => _isInitializing = true);

    await requestLocationPermission();
    await checkLocationService(context);

    if (serviceEnabledCtx && permissionGranted) {
      await ref.read(barbersControllerProvider.notifier).fetchNearestBarber();
    }

    setState(() => _isInitializing = false);
  }

  /// Запрашивает permission
  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      permissionGranted = false;
      if (mounted) {
        _showPermissionDialog();
      }
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      permissionGranted = true;
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(LucideIcons.mapPin, color: Color(0xff363062)),
            SizedBox(width: 12),
            Text('Location Permission'),
          ],
        ),
        content: const Text(
          'Location access is required to find nearby barbers. Please enable it in app settings.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff363062),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Проверка GPS
  Future<void> checkLocationService(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      serviceEnabledCtx = serviceEnabled;
    });

    if (!serviceEnabled && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(LucideIcons.navigation, color: Color(0xff363062)),
              SizedBox(width: 12),
              Text('GPS Required'),
            ],
          ),
          content: const Text(
            'Please enable GPS to find barbers near you.',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff363062),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
                await checkLocationService(context);
              },
              child: const Text('Enable GPS'),
            ),
          ],
        ),
      );
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
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (serviceEnabledCtx && permissionGranted) {
              await ref
                  .read(barbersControllerProvider.notifier)
                  .fetchNearestBarber();
            } else {
              await initLocationFlow();
            }
          },
          color: const Color(0xff363062),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 18),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _header(),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: BannerHome(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _searchBar(context),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nearest Babershop',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xff1C1C1C),
                        ),
                      ),
                      if (!_isInitializing &&
                          serviceEnabledCtx &&
                          permissionGranted &&
                          barbersState.nearestTenants.isNotEmpty)
                        Text(
                          '${barbersState.nearestTenants.length} found',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_isInitializing)
                  _buildLoadingState()
                else if (!serviceEnabledCtx || !permissionGranted)
                  _buildPermissionRequired()
                else
                  barbersState.status.when(
                    data: (_) {
                      final rawList = barbersState.nearestTenants;

                      final filteredRaw = _searchQuery.isEmpty
                          ? rawList
                          : rawList.where((barber) {
                              final name = barber.name.toLowerCase();
                              return name.contains(_searchQuery);
                            }).toList();

                      if (filteredRaw.isEmpty) {
                        return _buildEmptyState();
                      }

                      return Column(
                        children: [
                          _mostRecommendSection(context, filteredRaw),
                          const SizedBox(height: 24),
                          _buildSeeAllButton(),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                    loading: () => _buildLoadingState(),
                    error: (e, st) => _buildErrorState(e),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          children: [
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff363062)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Finding barbers near you...',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionRequired() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff363062).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.mapPin,
                size: 48,
                color: Color(0xff363062),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Location Access Required',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1C1C1C),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We need your location to show nearby barbers and provide the best service.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: initLocationFlow,
              icon: const Icon(LucideIcons.navigation),
              label: const Text('Enable Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff363062),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _searchQuery.isEmpty ? LucideIcons.users : LucideIcons.searchX,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _searchQuery.isEmpty
                  ? 'No Barbers Available'
                  : 'No Results Found',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xff1C1C1C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isEmpty
                  ? 'There are no barbers in your area yet. Check back later!'
                  : 'Try different keywords or check your spelling',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => _searchController.clear(),
                icon: const Icon(LucideIcons.x, size: 18),
                label: const Text('Clear Search'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xff363062),
                  side: const BorderSide(color: Color(0xff363062)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.alertCircle,
                size: 48,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Something Went Wrong',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff1C1C1C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Unable to load barbers. Please check your connection and try again.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (serviceEnabledCtx && permissionGranted) {
                  ref
                      .read(barbersControllerProvider.notifier)
                      .fetchNearestBarber();
                }
              },
              icon: const Icon(LucideIcons.refreshCw, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff363062),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeAllButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xff363062),
            side: const BorderSide(color: Color(0xff363062), width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View All Barbers',
                style: TextStyle(
                  color: Color(0xff363062),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 8),
              Icon(LucideIcons.arrowRight, size: 20),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Hello, ${widget.user.isNotEmpty ? widget.user : 'Guest'}!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1C1C1C),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xff363062).withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xff363062),
            child: Text(
              widget.user.isNotEmpty
                  ? widget.user.substring(0, 1).toUpperCase()
                  : 'G',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xff363062),
                    width: 2,
                  ),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                hintText: 'Search barbers or services...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff363062).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => FilterBottomSheet.show(context),
            style: IconButton.styleFrom(
              minimumSize: const Size(56, 56),
              backgroundColor: const Color(0xff363062),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icons/filter.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mostRecommendSection(BuildContext context, List barbers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: List.generate(barbers.length, (index) {
          final barber = barbers[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < barbers.length - 1 ? 16 : 0,
            ),
            child: BarberCard(barber: barber),
          );
        }),
      ),
    );
  }
}
