import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          title: Text('Twinsky Monkey Barber', style: TextStyle(fontSize: 12)),
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://via.placeholder.com/40'),
          ),
          subtitle: Row(
            children: [
              Icon(Icons.circle, color: Colors.green, size: 8),
              SizedBox(width: 4),
              Text('Online', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'End',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Profile Header

          // Chat messages
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                const Center(
                  child: Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildMessage(
                  'Good morning. I want to order a hair cutting service this afternoon',
                  '08:45 ✓',
                  isSentByMe: true,
                ),
                _buildMessage(
                  'Of course we are very open to this afternoon',
                  '09:15',
                  isSentByMe: false,
                ),
                _buildMessage(
                  'Please order via the Goban application\'s booking menu',
                  '09:17',
                  isSentByMe: false,
                ),
                _buildMessage(
                  'OK, thanks for the information',
                  '09:20 ✓',
                  isSentByMe: true,
                ),
              ],
            ),
          ),
          // Input Composer
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF363062),
                border: Border(top: BorderSide(color: Colors.white24)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file, color: Colors.white70),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type message...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for messages
  Widget _buildMessage(String text, String time, {required bool isSentByMe}) {
    final radius = const Radius.circular(16);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isSentByMe) const SizedBox(width: 40),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.lightBlue[100] : Colors.purple[300],
                borderRadius: BorderRadius.only(
                  topLeft: isSentByMe ? radius : Radius.zero,
                  topRight: isSentByMe ? radius : radius,
                  bottomLeft: isSentByMe ? radius : radius,
                  bottomRight: isSentByMe ? Radius.zero : radius,
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isSentByMe ? Colors.black87 : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
