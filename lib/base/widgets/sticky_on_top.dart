import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/styles/app_styles.dart';
import '../utils/chat_room_provider.dart';

class StickyOnTop extends StatelessWidget {
  final String agentName;

  const StickyOnTop({super.key, required this.agentName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Stick on top",
          style: AppStyles.t1.copyWith(fontWeight: FontWeight.w500)),
      content: Text("Do you want to put '$agentName' on the top of the list?"),
      actions: [
        TextButton(
            onPressed: () {
              final provider =
                  Provider.of<ChatRoomProvider>(context, listen: false);
              provider.stickOnTop(agentName);
              Navigator.of(context).pop("yes");
            },
            child: const Text("Yes")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"))
      ],

    );
  }
}
