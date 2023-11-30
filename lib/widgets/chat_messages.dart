import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
   // return StreamBuilder(stream: FirebaseFirestore.instance.collection('chat').snapshots(), builder: );
    return const Center(
      child: Text("No messages found"),
    );
  }
}
