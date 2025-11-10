import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repositories/chat_repository.dart';

class ChatController
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final ChatRepository _repository;

  ChatController(this._repository) : super(const AsyncValue.loading()) {
    loadBarbers();
  }

  void loadBarbers() {
    _repository.getBarbers().listen(
      (barbers) => state = AsyncValue.data(barbers),
      onError: (err, _) => state = AsyncValue.error(err, StackTrace.current),
    );
  }

  Future<String> createChatRoom({
    required String? clientName,
    required String? clientImageUrl,
    required String barberId,
    required String clientId,
    required String bookingId,
  }) async {
    return await _repository.createChatRoom(
      barberId: barberId,
      clientId: clientId,
      bookingId: bookingId,
      clientName: clientName,
      clientImageUrl: clientImageUrl,
    );
  }
}
