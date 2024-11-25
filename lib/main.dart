import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:individual_project/base/utils/chat_room_provider.dart';
import 'package:provider/provider.dart';

import 'base/bottom_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩 초기화
  await dotenv.load(fileName: "assets/.env"); // 환경 변수 로드

  runApp(
    ChangeNotifierProvider(
      create: (_) => ChatRoomProvider(),
      child: const MyApp(),
    ),
  );
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
