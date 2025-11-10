import 'package:barberly/core/firebase_service/firebase_auth_provider.dart';
import 'package:barberly/features/chat/providers/chat_provider.dart';
import 'package:barberly/features/chat/screens/message_screen.dart';
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
) {
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
              child: Consumer(
                builder: (context, ref, _) {
                  final barbersAsync = ref.watch(chatControllerProvider);

                  return barbersAsync.when(
                    data: (barbers) {
                      // Фильтрация барберов по поисковому запросу
                      final filteredBarbers = searchQuery.isEmpty
                          ? barbers
                          : barbers.where((barber) {
                              final name =
                                  (barber['name'] as String?)?.toLowerCase() ??
                                  '';
                              final bio =
                                  (barber['bio'] as String?)?.toLowerCase() ??
                                  '';
                              return name.contains(searchQuery) ||
                                  bio.contains(searchQuery);
                            }).toList();

                      if (filteredBarbers.isEmpty) {
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
                                searchQuery.isEmpty
                                    ? 'No chats available'
                                    : 'No results found',
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
                        itemCount: filteredBarbers.length,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (context, index) {
                          final barber = filteredBarbers[index];
                          return _ChatListTile(
                            barber: barber,
                            user: user,
                            ref: ref,
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(
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
                            err.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
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

class _ChatListTile extends StatefulWidget {
  final Map<String, dynamic> barber;
  final User? user;
  final WidgetRef ref;

  const _ChatListTile({
    required this.barber,
    required this.user,
    required this.ref,
  });

  @override
  State<_ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<_ChatListTile> {
  bool _isLoading = false;

  Future<void> _openChat() async {
    if (widget.user == null || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final bookingId = 'booking001';
      final chatRoomId = await widget.ref
          .read(chatControllerProvider.notifier)
          .createChatRoom(
            barberId: widget.barber['uid'],
            clientName: widget.user!.displayName,
            clientImageUrl: widget.user!.photoURL,
            clientId: widget.user!.uid,
            bookingId: bookingId,
          );

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MessagesScreen(
              chatRoomId: chatRoomId,
              barberId: widget.barber['uid'],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open chat: $e'),
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
    return ListTile(
      onTap: _isLoading ? null : _openChat,
      enabled: !_isLoading,
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.barber['imageUrl'] ??
                  'https://i.postimg.cc/cCsYDjvj/user-2.png',
            ),
          ),
          if (widget.barber['online'] ?? false)
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
              widget.barber['name'] ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (_isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
      subtitle: Text(
        widget.barber['bio'] ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
