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
  // void setupPushNotification() async {
  //   final fcm = FirebaseMessaging.instance;
  //   await fcm.requestPermission();
  //   final token=await fcm.getToken();
  //   print(token); //you could send this token via (HTTP or firestore)
  // }
  void setupPushNotification() async {
    final fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BBbY-Vz4Gq-6QyN_qOB-hIb7dy15E961RYOkn0gHkhjN65rwmgErJkRxrM-wEDTHqFdfJ3DsPYVR9PoJkmhUIKQ");
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {})
        .onError((err) {
      print("Cannot generate token");
    });
  }

  @override
  void initState() {
    super.initState();
    setupPushNotification();
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
