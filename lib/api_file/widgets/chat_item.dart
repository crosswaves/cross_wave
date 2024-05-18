import 'package:flutter/material.dart';

import '../../domain/model/profile.dart';

class ChatItem extends StatelessWidget {
  final String text;
  final bool isMe;
  final Future<Profile> profileFuture;

  const ChatItem({
    super.key,
    required this.text,
    required this.isMe,
    required this.profileFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ProfileContainer(isMe: isMe, profileFuture: profileFuture),
          if (!isMe) const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(15),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.60,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF8D8D92)
                      : const Color(0xFF4F5056),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: Radius.circular(isMe ? 15 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 15),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 15),
          if (isMe) ProfileContainer(isMe: isMe, profileFuture: profileFuture),
        ],
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  ProfileContainer({
    super.key,
    required this.isMe,
    required this.profileFuture,
  });

  final bool isMe;

  // FutureBuilder 캐싱
  final Future<Profile> profileFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
      future: profileFuture,
      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          return Container(
            alignment: Alignment.center,
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: Radius.circular(isMe ? 0 : 15),
                bottomRight: Radius.circular(isMe ? 15 : 0),
              ),
              image: isMe
                  ? DecorationImage(
                      image: NetworkImage(snapshot.data!.profilePicture ?? ''),
                      fit: BoxFit.cover,
                    )
                  // : const DecorationImage(
                  //     image: AssetImage('assets/computer.png'),
                  //     fit: BoxFit.cover,
                  //   ),
                  : null,
            ),
            child: isMe
                ? CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data!.profilePicture ?? ''),
                    radius: 20,
                    backgroundColor: Colors.transparent,
                  )
                : Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    child: Icon(
                      Icons.computer,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
          );
        } else {
          return const Text('데이터를 찾을 수 없습니다.');
        }
      },
    );
  }
}
