import 'package:flutter/material.dart';

import '../res/styles/app_styles.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String agentName;

  const ChatAppBar({super.key, required this.agentName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppStyles.chatBackground,
      title: Text(
        agentName,
        style: AppStyles.chatbar,
      ),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60.0);
}
