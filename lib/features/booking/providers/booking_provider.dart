import 'package:barberly/core/network/api_service.dart';
import 'package:barberly/features/booking/controllers/booking_controller.dart';
import 'package:barberly/features/booking/repositories/booking_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final api = ApiService();
  return BookingRepository(api);
});

final bookingControllerProvider = Provider<BookingController>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return BookingController(repository);
});
