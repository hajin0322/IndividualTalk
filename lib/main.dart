import 'package:flutter/material.dart';
import 'package:individual_project/base/utils/chat_room_provider.dart';
import 'package:provider/provider.dart';

import 'base/bottom_nav_bar.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ChatRoomProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavBar(),
    );
  }
}
