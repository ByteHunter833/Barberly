// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gobar/models/chat_message.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<ChatMessage> messages = [
    ChatMessage(
      text: 'Hi Sajol!',
      isSender: false,
      messageStatus: MessageStatus.viewed,
    ),
    ChatMessage(
      text: 'Hello! How are you?',
      isSender: true,
      messageStatus: MessageStatus.viewed,
    ),
    ChatMessage(
      text: 'I am good, thanks!',
      isSender: false,
      messageStatus: MessageStatus.viewed,
    ),
    ChatMessage(
      text: 'Great to hear!',
      isSender: true,
      messageStatus: MessageStatus.viewed,
    ),
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatMessage(
      text: text,
      isSender: true,
      messageStatus: MessageStatus.viewed,
    );

    setState(() {
      messages.add(newMessage);
    });

    _controller.clear();

    // Скролл вниз после добавления
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
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
        title: const Row(
          children: [
            BackButton(),
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://i.postimg.cc/cCsYDjvj/user-2.png',
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kristin Watson', style: TextStyle(fontSize: 16)),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) =>
                    TextMessageWidget(message: messages[index]),
              ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type message...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
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
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xff4A4572)),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Text Message Widget ---
class TextMessageWidget extends StatelessWidget {
  final ChatMessage message;
  const TextMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: message.isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            const CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(
                'https://i.postimg.cc/cCsYDjvj/user-2.png',
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isSender
                    ? const Color(0xffECF0F7)
                    : const Color(0xff4A4572),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: message.isSender
                      ? const Radius.circular(16)
                      : Radius.zero,
                  bottomRight: message.isSender
                      ? Radius.zero
                      : const Radius.circular(16),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isSender ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          if (message.isSender) MessageStatusDot(status: message.messageStatus),
        ],
      ),
    );
  }
}

// --- Status Dot ---
class MessageStatusDot extends StatelessWidget {
  final MessageStatus status;
  const MessageStatusDot({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    switch (status) {
      case MessageStatus.notSent:
        dotColor = Colors.red;
        break;
      case MessageStatus.notView:
        dotColor = Colors.grey.withOpacity(0.4);
        break;
      case MessageStatus.viewed:
        dotColor = Colors.green;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(left: 6),
      height: 12,
      width: 12,
      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
      child: const Icon(Icons.done, size: 12, color: Colors.white),
    );
  }
}
