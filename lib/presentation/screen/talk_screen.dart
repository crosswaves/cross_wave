import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api_file/providers/chats_provider.dart';
import '../../api_file/widgets/chat_item.dart';
import '../../api_file/widgets/my_app_bar.dart';
import '../../api_file/widgets/text_and_voice_field.dart';

class TalkScreen extends StatelessWidget {
  const TalkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        body: Column(
          children: [
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                final chats = ref.watch(chatsProvider).reversed.toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: chats.length,
                  itemBuilder: (context, index) => ChatItem(
                    text: chats[index].message,
                    isMe: chats[index].isMe,
                  ),
                );
              }),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: TextAndVoiceField(),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
