import 'package:flutter/material.dart';
import 'package:individual_project/base/utils/chat_room_provider.dart';
import 'package:provider/provider.dart';

import '../res/styles/app_styles.dart';

class StickyOnTop extends StatelessWidget {
  final String agentName;
  final ChatRoomSortOption sortOption;

  const StickyOnTop(
      {super.key, required this.agentName, required this.sortOption});

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
              provider.stickOnTop(agentName, sortOption);
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
