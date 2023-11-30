import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firestore/widgets/message_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text("No messages found"),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text("Something went wrong..."),
          );
        }
        final loadedMessage = chatSnapshots.data!.docs;
        return Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 13,
                right: 13,
              ),
              reverse: true, //display message from bottom to top
              itemCount: loadedMessage.length,
              itemBuilder: (ctx, index) {
                // return Text(loadedMessage[index].data()['text']);
                final chatMessage = loadedMessage[index].data();
                final nextChatMessage = index + 1 < loadedMessage.length
                    ? loadedMessage[index + 1].data()
                    : null;
                final currentMessageUserId = chatMessage['userId'];
                final nextMessageUserId =
                    nextChatMessage != null ? nextChatMessage['userId'] : null;
                final nextUserIsSame =
                    nextMessageUserId == currentMessageUserId;
                if (nextUserIsSame) {
                  return MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId,
                  );
                } else {
                  return MessageBubble.first(
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: authenticatedUser.uid == currentMessageUserId);
                }
              }),
        );
      },
    );
  }
}
