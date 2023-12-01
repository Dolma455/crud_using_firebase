import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firestore/widgets/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  getFCM() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken(
          vapidKey:
              "BHu8f1_GJtXqLxVYn_HT1eq8G_EuM6VYcmYgAbPvn-eHpOzNwLC10_fFM1Lgh44KtjAAmwxYuA2uz30rKT2AwQY");
      log("FCM is $fcmToken");
    } on FirebaseException catch (e) {
      log("ERROR is ${e.message}");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  File? _selectedImage;
  void _submit() async {
    final isValid = _formkey.currentState!.validate();
    if (!isValid || !_isLogin && _selectedImage == null) {
      // show error messgae
      return;
    }

    _formkey.currentState!.save();

    try {
      if (_isLogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCredential);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCredentials);

        FirebaseFirestore.instance
            .collection('userss')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'password': _enteredPassword
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: getFCM,
        label: const Text("Get FCM"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  width: 200,
                  child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/134/134932.png')),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!_isLogin)
                              UserImagePicker(
                                onPickImage: (pickedImage) {
                                  _selectedImage = pickedImage;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredEmail = newValue!;
                              },
                            ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 8) {
                                    return 'Please enter at least 8 characters';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _enteredUsername = newValue!;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 8) {
                                  return 'Password must be atleast 8 characters long';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredPassword = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _submit();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(_isLogin ? 'Login' : 'Sign Up'),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Create an account'
                                    : 'Already have an account? Login.'))
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
