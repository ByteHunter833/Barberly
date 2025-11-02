// --- Model ---
enum MessageStatus { notSent, notView, viewed }

class ChatMessage {
  final String text;
  final bool isSender;
  final MessageStatus messageStatus;

  ChatMessage({
    required this.text,
    required this.isSender,
    required this.messageStatus,
  });
}
