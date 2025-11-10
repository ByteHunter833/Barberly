import 'package:barberly/core/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получаем список всех барберов
  Stream<List<Map<String, dynamic>>> getBarbers() {
    return _firestore.collection('barbers').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Создаем chatroom
  Future<String> createChatRoom({
    required String barberId,
    required String clientId,
    required String bookingId,
    required String? clientImageUrl,
    required String? clientName,
  }) async {
    final query = await _firestore
        .collection('chatrooms')
        .where('barberId', isEqualTo: barberId)
        .where('clientId', isEqualTo: clientId)
        .get();

    if (query.docs.isNotEmpty) return query.docs.first.id;

    final chatRoomRef = _firestore.collection('chatrooms').doc();
    await chatRoomRef.set({
      'barberId': barberId,
      'clientId': clientId,
      'bookingId': bookingId,
      'clientName': clientName,
      'clientImageUrl': clientImageUrl,
      'createdAt': DateTime.now().toIso8601String(),
      'lastMessage': '',
      'lastMessageTime': null,
      'unreadCount': 0,
    });

    return chatRoomRef.id;
  }

  // Получаем сообщения
  Stream<List<ChatMessage>> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return ChatMessage.fromMap(data, doc.id);
          }).toList();
        });
  }

  // Отправка сообщения
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final messagesRef = _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages');

    final message = ChatMessage(
      id: '',
      senderId: senderId,
      receiverId: receiverId,
      message: text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    await messagesRef.add(message.toMap());

    // Обновляем chatroom
    await _firestore.collection('chatrooms').doc(chatRoomId).update({
      'lastMessage': text,
      'lastMessageTime': DateTime.now().toIso8601String(),
    });
  }
}
