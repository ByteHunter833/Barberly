import 'package:barberly/features/booking/repositories/booking_repository.dart';
import 'package:flutter/material.dart';

class BookingController extends ChangeNotifier {
  final BookingRepository repository;
  bool _isLoading = false;
  String? _error;

  BookingController(this.repository);

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> createOrder({
    required String barberId,
    required int tenantId,
    required List<String> serviceIds,
    required String dateTime,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await repository.createOrder(
        barberId: barberId,
        tenantId: tenantId,
        serviceIds: serviceIds,
        dateTime: dateTime,
      );

      _isLoading = false;
      notifyListeners();

      if (result['success'] == true) {
        return true;
      } else {
        _error = result['message'] ?? 'Failed to create order';
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
