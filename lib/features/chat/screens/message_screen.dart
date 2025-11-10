// ignore_for_file: deprecated_member_use

import 'package:barberly/core/firebase_service/firebase_auth_provider.dart';
import 'package:barberly/core/models/chat_message.dart';
import 'package:barberly/features/chat/repositories/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  final String chatRoomId;
  final String barberId;

  const MessagesScreen({
    super.key,
    required this.chatRoomId,
    required this.barberId,
  });

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatRepository _chatRepo = ChatRepository();
  Map<String, dynamic>? barberData;
  bool _isLoading = false;

  User? get user => ref.watch(authStateProvider).value;

  late Stream<List<ChatMessage>> _messagesStream;

  @override
  void initState() {
    super.initState();
    _messagesStream = _chatRepo.getMessages(widget.chatRoomId);
    _loadBarberProfile();

    // Автоскролл при появлении новых сообщений
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadBarberProfile() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('barbers')
        .doc(widget.barberId)
        .get();

    if (snapshot.exists && mounted) {
      setState(() {
        barberData = snapshot.data();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients && mounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || user == null || _isLoading) return;

    // Сохраняем текст и сразу очищаем поле
    final messageText = text;

    setState(() {
      _isLoading = true;
    });

    // Очищаем поле ДО отправки
    _controller.clear();

    // Убираем фокус с клавиатуры для лучшего UX
    FocusScope.of(context).unfocus();

    try {
      await _chatRepo.sendMessage(
        receiverId: widget.barberId,
        chatRoomId: widget.chatRoomId,
        senderId: user!.uid,
        text: messageText,
      );

      // Скролл к последнему сообщению
      _scrollToBottom();
    } catch (e) {
      // В случае ошибки возвращаем текст обратно
      if (mounted) {
        _controller.text = messageText;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const BackButton(),
            CircleAvatar(
              backgroundImage: NetworkImage(
                barberData?['imageUrl'] ??
                    'https://i.postimg.cc/cCsYDjvj/user-2.png',
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barberData?['name'] ?? 'Loading...',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  barberData != null && barberData!['workingHours'] != null
                      ? 'Online'
                      : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        barberData != null &&
                            barberData!['workingHours'] != null
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet.\nStart the conversation!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final messages = snapshot.data!;

                // Автоскролл при получении новых сообщений
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isSender = msg.senderId == user!.uid;

                    return _MessageBubble(
                      message: msg,
                      isSender: isSender,
                      barberImageUrl: barberData?['imageUrl'],
                    );
                  },
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type message...',
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  enabled: !_isLoading,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xff4A4572),
                        ),
                      ),
                    )
                  : const Icon(Icons.send, color: Color(0xff4A4572)),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isSender;
  final String? barberImageUrl;

  const _MessageBubble({
    required this.message,
    required this.isSender,
    this.barberImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender)
            CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(
                barberImageUrl ?? 'https://i.postimg.cc/cCsYDjvj/user-2.png',
              ),
            ),
          if (!isSender) const SizedBox(width: 8),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSender
                      ? const Color(0xffECF0F7)
                      : const Color(0xff4A4572),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isSender
                        ? const Radius.circular(16)
                        : Radius.zero,
                    bottomRight: isSender
                        ? Radius.zero
                        : const Radius.circular(16),
                  ),
                ),
                child: Text(
                  message.message,
                  style: TextStyle(
                    color: isSender ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
