import 'package:flutter/material.dart';
import '../base/utils/chat_room_provider.dart';
import 'package:provider/provider.dart';
import '../base/widgets/agent_name.dart';
import './widgets/top_app_bar.dart';
import '../screen/sort_date.dart';
import '../screen/sort_name.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAgentNameDialog() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return const AgentName();
        }
    ).then((agentName) {
      if (mounted && agentName != null) {
        // Provider를 통해 채팅방 추가
        Provider.of<ChatRoomProvider>(context, listen: false).addNewChatRoom(agentName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(onChatBubblePressed: _showAgentNameDialog),
      body: TabBarView(
        controller: _tabController,
        children: const [SortName(), SortDate()],
      ),
      bottomNavigationBar: Material(
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.brown,
          labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.transparent,
          tabs: const [
            Tab(
              text: 'Sort by name',
              icon: Icon(Icons.person),
            ),
            Tab(
              text: 'Sort by date',
              icon: Icon(Icons.message),
            )
          ],
        ),
      ),
    );
  }
}