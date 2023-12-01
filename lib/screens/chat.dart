import 'dart:developer';

import 'package:crud_firestore/widgets/chat_messages.dart';
import 'package:crud_firestore/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotification() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken(
          vapidKey:
              "BBbY-Vz4Gq-6QyN_qOB-hIb7dy15E961RYOkn0gHkhjN65rwmgErJkRxrM-wEDTHqFdfJ3DsPYVR9PoJkmhUIKQ");

      log("FCM Token: $fcmToken");
      FirebaseMessaging.instance.subscribeToTopic('chat');
    } catch (e) {
      log("Failed to get FCM token: $e");
    }
  }

  @override
  void initState() {
    setupPushNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Chat"),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
        body: const Column(
          children: [
            ChatMessages(),
            NewMessage(),
          ],
        ));
  }
}
