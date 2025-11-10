import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repositories/chat_repository.dart';
import '../controllers/chat_controller.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository());

final chatControllerProvider =
    StateNotifierProvider<
      ChatController,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) => ChatController(ref.watch(chatRepositoryProvider)));
