import 'package:barberly/core/firebase_service/firebase_auth_provider.dart';
import 'package:barberly/features/chat/repositories/chat_repository.dart';
import 'package:barberly/features/chat/screens/message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = ['Active Chat', 'Finished'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ChatRepository _chatRepo = ChatRepository();

  User? get user {
    final authState = ref.watch(authStateProvider);
    return authState.maybeWhen(data: (user) => user, orElse: () => null);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color(0xff363062),
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  'Barberly',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          _tabBar(_tabController, tabs),
          _chatList(
            _tabController,
            tabs,
            currentUser,
            _searchController,
            _searchQuery,
            _chatRepo,
          ),
        ],
      ),
    );
  }
}

Widget _tabBar(TabController tabController, List<String> tabs) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: const Color(0xffEDEFFB),
      borderRadius: BorderRadius.circular(20),
    ),
    child: TabBar(
      dividerColor: Colors.transparent,
      controller: tabController,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      indicatorPadding: const EdgeInsets.symmetric(vertical: 5),
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey.shade600,
      tabs: tabs
          .map(
            (tab) => Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  tab,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

Widget _chatList(
  TabController tabController,
  List<String> tabs,
  User? user,
  TextEditingController searchController,
  String searchQuery,
  ChatRepository chatRepo,
) {
  if (user == null) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Please sign in to view chats',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  return Expanded(
    child: TabBarView(
      controller: tabController,
      children: tabs.map((tab) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search chat',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  filled: true,
                  fillColor: const Color(0xffEBF0F5),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/search.svg'),
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: chatRepo.getChatRoomsByClient(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading chats',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    print(snapshot.data!.docs);
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No chats yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start chatting with barbers',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final chatRooms = snapshot.data!.docs;

                  // Фильтрация чатов по поисковому запросу
                  final filteredRooms = searchQuery.isEmpty
                      ? chatRooms
                      : chatRooms.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final clientName =
                              (data['clientName'] as String?)?.toLowerCase() ??
                              '';
                          final lastMessage =
                              (data['lastMessage'] as String?)?.toLowerCase() ??
                              '';
                          return clientName.contains(searchQuery) ||
                              lastMessage.contains(searchQuery);
                        }).toList();

                  if (filteredRooms.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredRooms.length,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      final chatRoom = filteredRooms[index];
                      final data = chatRoom.data() as Map<String, dynamic>;
                      print(data);
                      return _ChatRoomTile(
                        chatRoomId: chatRoom.id,
                        chatRoomData: data,
                        currentUserId: user.uid,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    ),
  );
}

class _ChatRoomTile extends StatefulWidget {
  final String chatRoomId;
  final Map<String, dynamic> chatRoomData;
  final String currentUserId;

  const _ChatRoomTile({
    required this.chatRoomId,
    required this.chatRoomData,
    required this.currentUserId,
  });

  @override
  State<_ChatRoomTile> createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<_ChatRoomTile> {
  bool _isLoading = false;
  Map<String, dynamic>? _barberData;

  @override
  void initState() {
    super.initState();
    _loadBarberData();
  }

  Future<void> _loadBarberData() async {
    try {
      final barberId = widget.chatRoomData['barberId'];
      if (barberId == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('barbers')
          .doc(barberId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _barberData = snapshot.data();
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _openChat() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MessagesScreen(
            chatRoomId: widget.chatRoomId,
            barberId: widget.chatRoomData['barberId'],
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    try {
      DateTime dateTime;
      if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else if (timestamp is Timestamp) {
        dateTime = timestamp.toDate();
      } else {
        return '';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final barberName = _barberData?['name'] ?? 'Loading...';
    final barberImageUrl =
        _barberData?['imageUrl'] ?? 'https://i.postimg.cc/cCsYDjvj/user-2.png';
    final lastMessage = widget.chatRoomData['lastMessage'] ?? 'No messages yet';
    final lastMessageTime = widget.chatRoomData['lastMessageTime'];
    final unreadCount = widget.chatRoomData['unreadCount'] ?? 0;
    final isOnline = _barberData?['online'] ?? false;

    return ListTile(
      onTap: _isLoading ? null : _openChat,
      enabled: !_isLoading,
      leading: Stack(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(barberImageUrl)),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              barberName,
              style: TextStyle(
                fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
          if (lastMessageTime != null)
            Text(
              _formatTimestamp(lastMessageTime),
              style: TextStyle(
                fontSize: 12,
                color: unreadCount > 0 ? const Color(0xff363062) : Colors.grey,
                fontWeight: unreadCount > 0
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          if (_isLoading) ...[
            const SizedBox(width: 8),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: unreadCount > 0
                    ? FontWeight.w500
                    : FontWeight.normal,
                color: unreadCount > 0 ? Colors.black87 : Colors.grey[600],
              ),
            ),
          ),
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xff363062),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
