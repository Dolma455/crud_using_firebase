import 'package:crud_firestore/screens/auth.dart';
import 'package:crud_firestore/screens/chat.dart';
import 'package:crud_firestore/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyD9k_6i94Hapz_MS1eg1xOSB97Nk8Nivgc',
      authDomain: 'flutterweb-968c2.firebaseapp.com',
      projectId: 'flutterweb-968c2',
      storageBucket: 'flutterweb-968c2.appspot.com',
      messagingSenderId: '225378996225',
      appId: '1:225378996225:web:72e8a8887dbabad4953000',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SPlashScreen();
            }
            if (snapshot.hasData) {
              return const ChatScreen();
            }
            return const AuthScreen();
          }),
    );
  }
}
