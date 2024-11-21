import 'package:flutter/material.dart';

import '../res/styles/app_styles.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchPressed;
  final VoidCallback? onChatBubblePressed;
  final VoidCallback? onSettingsPressed;

  const TopAppBar({super.key, this.onSearchPressed, this.onChatBubblePressed, this.onSettingsPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Chatting",
        style: AppStyles.appbar,
      ),
      actions: [
        IconButton(onPressed: onSearchPressed, icon: const Icon(Icons.search)),
        IconButton(
            onPressed: onChatBubblePressed,
            icon: const Icon(Icons.chat_bubble_outline)),
        IconButton(
          onPressed: onSettingsPressed,
          icon: const Icon(Icons.settings_outlined),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
