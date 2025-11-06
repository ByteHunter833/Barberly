import 'package:barberly/screens/chat/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = ['Active Chat', 'Finished'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> messages = [
    {
      'name': 'Varcity Barbershop',
      'message': 'I want to consult on the latest haircut.',
      'time': '16:30',
      'unread': 0,
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'online': true,
    },
    {
      'name': 'Twinsky Monkey Barber',
      'message': 'Is there a recommendation for...',
      'time': '21:30',
      'unread': 0,
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'online': true,
    },
    {
      'name': 'Baberman Haircut',
      'message': 'Sorry, we serve from 7 am to 9 pm.',
      'time': '18:00',
      'unread': 2,
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'online': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
        // bottom:
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          _tabBar(_tabController, tabs),
          _chatList(_tabController, tabs, messages),
        ],
      ),
    );
  }
}

Widget _tabBar(TabController tabController, List tabs) {
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

Widget _chatList(TabController tabController, List tabs, List messages) {
  return Expanded(
    child: TabBarView(
      controller: tabController,
      children: tabs.map((tab) {
        return Column(
          children: [
            const SizedBox(height: 12),
            _stories(messages),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search chat',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  filled: true,
                  fillColor: const Color(0xffEBF0F5),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/search.svg'),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const MessagesScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                final begin = const Offset(1.0, 0.0);
                                final end = Offset.zero;
                                final tween = Tween(begin: begin, end: end);
                                final tweenanimation = animation.drive(tween);
                                return SlideTransition(
                                  position: tweenanimation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(msg['avatar']),
                        ),
                        if (msg['online'])
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      msg['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      msg['message'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(msg['time'], style: const TextStyle(fontSize: 12)),
                        if (msg['unread'] > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.purple,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              msg['unread'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
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

Widget _stories(List messages) {
  return SizedBox(
    height: 60,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xff363062),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        const SizedBox(width: 12),
        ...messages.map(
          (msg) => Padding(
            padding: const EdgeInsets.only(right: 12),

            child: CircleAvatar(
              backgroundImage: NetworkImage(msg['avatar']),
              radius: 31,
            ),
          ),
        ),
      ],
    ),
  );
}
