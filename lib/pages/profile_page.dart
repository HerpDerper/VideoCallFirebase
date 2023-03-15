import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_video_call/utils/image_utils.dart';

import '../models/account.dart';
import '../utils/app_utils.dart';
import '../screens/auth_screen.dart';
import '../utils/firebase_utils.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  late Account account;

  void _updateEmail(String email, String password) async {
    if (account.password != password) {
      AppUtils.showInfoMessage('Invalid password', context);
      return;
    }
    try {
      account.email = email;
      await FirebaseUtils.auth.currentUser!.updateEmail(email);
      FirebaseUtils.setCollection('Accounts');
      FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).set(account.toJson());
      AppUtils.switchScreen(const AuthScreen(), context);
      AppUtils.showInfoMessage('Success', context);
    } on FirebaseAuthException {
      AppUtils.showInfoMessage('Current email is already in use', context);
    }
  }

  void _updateUserName(String userName, String password) async {
    if (account.password != password) {
      AppUtils.showInfoMessage('Invalid password', context);
      return;
    }
    account.userName = userName;
    FirebaseUtils.setCollection('Accounts');
    FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).set(account.toJson());
    AppUtils.showInfoMessage('Success', context);
  }

  void _updatePassword(String oldPassword, String newPassword, String newPasswordSubmit) async {
    if (account.password != oldPassword) {
      AppUtils.showInfoMessage('Invalid password', context);
      return;
    }
    if (newPassword != newPasswordSubmit) {
      AppUtils.showInfoMessage('Passwords do not match', context);
      return;
    }
    if (newPassword == oldPassword) {
      AppUtils.showInfoMessage('Old password matches new password', context);
      return;
    }
    account.password = newPassword;
    FirebaseUtils.setCollection('Accounts');
    await FirebaseUtils.auth.currentUser!.updatePassword(newPassword);
    FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).set(account.toJson());
    AppUtils.switchScreen(const AuthScreen(), context);
    AppUtils.showInfoMessage('Success', context);
  }

  Future<Account> _getAccount() async {
    FirebaseUtils.setCollection('Accounts');
    final accountReference = FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid);
    final snapshot = await accountReference.get();
    return Account.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Future<String> _getAccountImage(String imageNmae) => FirebaseUtils.storage.ref().child(imageNmae).getDownloadURL();

  void _signOut() {
    FirebaseUtils.auth.signOut();
    AppUtils.switchScreen(const AuthScreen(), context);
  }

  Future _updateImage() async {
    final image = await ImageUtils.pickImage();
    if (image == null) return;
    File? croppedImage = await ImageUtils.cropImage(image);
    if (croppedImage == null) return;
    _uploadFile(croppedImage);
  }

  void _uploadFile(File image) async {
    String imageName = '${DateTime.now().millisecondsSinceEpoch}.jpeg';
    await FirebaseUtils.storage.ref().child(imageName).putFile(image);
    account.image = imageName;
    FirebaseUtils.setCollection('Accounts');
    FirebaseFirestore.instance.collection('Accounts').doc(FirebaseUtils.auth.currentUser!.uid).set(account.toJson());
    setState(() => account);
  }

  @override
  void initState() {
    account = Account(email: '', userName: '', password: '', birthDate: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Account>(
      future: _getAccount(),
      builder: (context, snapshotAccount) {
        if (snapshotAccount.hasData) {
          account = snapshotAccount.data!;
          controllerEmail.text = account.email;
          controllerUsername.text = account.userName;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: _getAccountImage(account.image),
              builder: (context, snapshotImage) {
                if (snapshotImage.connectionState == ConnectionState.waiting) {
                  return const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 123, 118, 155),
                    ),
                  );
                }
                return InkWell(
                  onTap: () => _updateImage(),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(snapshotImage.data.toString()),
                    backgroundColor: Colors.transparent,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
              child: Center(
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controllerUsername,
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return 'Username must not be empty';
                          }
                          if (value.length < 8 || value.length >= 16) {
                            return 'Username must be from 8 to 16 characters';
                          }
                          return null;
                        }),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'Username',
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(30, 8, 30, 0),
                      ),
                      TextFormField(
                        controller: controllerEmail,
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return 'Email must not be empty';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Email entered incorrectly';
                          }
                          return null;
                        }),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          labelText: 'Email',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          shape: const StadiumBorder(),
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () => _updateEmail(controllerEmail.text, controllerPassword.text),
                        child: const Text(
                          'Done',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                    ),
                    SizedBox(
                      height: 35,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          shape: const StadiumBorder(),
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () => _signOut(),
                        child: const Text(
                          'Log out',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
