import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.username,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = true;

  //Create a bubble message that continues a sequence
  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : isFirstInSequence = false,
        username = null;
  //Whether or not this message bubble is the first in a sequence of messages from the same user

  final bool isFirstInSequence;
  //Not required if the message is no tthe first in a sequence
  final String? username;
  final String message;

  //Control how the message bubble will be aligned
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Positioned(
        //   top: 15,
        //   //Align username to the right, if the message is from me
        //   right: isMe ? 0 : null,
        //   child: Text(userImage!),
        // ),
        Container(
          //Add some margin to the edges of the messages, to allow spacefor the username
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            //The side of the chat screen the message should show at
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  //First message in the sequence provide visual buffer at the top

                  // if (isFirstInSequence)
                  //   const SizedBox(
                  //     height: 18,
                  //   ),
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Text(
                        username!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                        color: isMe
                            ? Colors.grey[300]
                            : theme.colorScheme.secondary.withAlpha(200),
                        borderRadius: BorderRadius.only(
                            topLeft: !isMe && isFirstInSequence
                                ? Radius.zero
                                : const Radius.circular(12),
                            bottomLeft: const Radius.circular(12),
                            bottomRight: const Radius.circular(12))),
                    //Set some reasonable constraints on the width of the message bubble so it can adjust
                    //to the amount of text it should show
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        height: 1.3,
                        color: isMe
                            ? Colors.black87
                            : theme.colorScheme.onSecondary,
                      ),
                      softWrap: true,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
