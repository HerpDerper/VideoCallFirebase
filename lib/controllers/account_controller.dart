import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/account.dart';
import '../utils/app_utils.dart';
import '../utils/image_utils.dart';
import '../screens/home_screen.dart';
import '../screens/auth_screen.dart';
import '../utils/firebase_utils.dart';

class AccountController {
  Account? account;
  BuildContext context;

  AccountController({required this.context, this.account});

  static Future<Account> getAccountById(String accountId) {
    FirebaseUtils.setCollection('Accounts');
    return FirebaseUtils.collection.doc(accountId).snapshots().map((snapshot) => Account.fromSnapshot(snapshot)).first;
  }

  static Future<String> getAccountImageByName(String imageName) => FirebaseUtils.storage.ref().child(imageName).getDownloadURL();

  Stream<Account> getMyAccount() {
    FirebaseUtils.setCollection('Accounts');
    return FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).snapshots().map((snapshot) => account = Account.fromSnapshot(snapshot));
  }

  Future<String> getAccountImage() => FirebaseUtils.storage.ref().child(account!.image).getDownloadURL();

  Stream<List<Account>> getFriends() {
    FirebaseUtils.setCollection('Accounts');
    StreamController<List<Account>> streamController = StreamController.broadcast();
    List<Account> friendsList = [];
    for (String friendId in account!.friends) {
      AccountController.getAccountById(friendId).then((account) {
        friendsList.add(account);
        streamController.sink.add(friendsList);
      });
    }
    return streamController.stream;
  }

  Stream<List<Account>> searchAccounts(String userName) {
    FirebaseUtils.setCollection('Accounts');
    return FirebaseUtils.collection
        .where('userName', isEqualTo: userName)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Account.fromSnapshot(doc)).toList());
  }

  void createAccount(String email, String userName, String password, String birthDate) async {
    try {
      await FirebaseUtils.auth.createUserWithEmailAndPassword(email: email, password: password).then((newUser) {
        FirebaseUtils.setCollection('Accounts');
        FirebaseUtils.collection.doc(newUser.user!.uid).set(Account(email: email, userName: userName, password: password, birthDate: birthDate).toJson());
        AppUtils.switchScreen(const HomeScreen(), context);
      });
    } on FirebaseAuthException {
      AppUtils.showInfoMessage('Current email is already in use', context);
    }
  }

  Future updateImage() async {
    final image = await ImageUtils.pickImage();
    if (image == null) return;
    File? croppedImage = await ImageUtils.cropImage(image);
    if (croppedImage == null) return;
    _uploadFile(croppedImage);
  }

  void updateEmail(String email, String password) async {
    if (account!.password != password) {
      AppUtils.showInfoMessage('Invalid password', context);
      return;
    }
    try {
      account!.email = email;
      await FirebaseUtils.auth.currentUser!.updateEmail(email);
      FirebaseUtils.setCollection('Accounts');
      FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).set(account!.toJson());
      FirebaseUtils.auth.signInWithEmailAndPassword(email: email, password: password).then((_) => AppUtils.showInfoMessage('Success', context));
    } on FirebaseAuthException catch (e) {
      AppUtils.showInfoMessage(e.message.toString(), context);
    }
  }

  void updateStatus(bool status) {
    FirebaseUtils.setCollection('Accounts');
    FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).update({'status': status});
  }

  void updateUsername(String username, String password) {
    if (account!.password != password) {
      AppUtils.showInfoMessage('Invalid password', context);
      return;
    }
    account!.userName = username;
    FirebaseUtils.setCollection('Accounts');
    FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).set(account!.toJson());
    AppUtils.showInfoMessage('Success', context);
  }

  void updatePassword(String oldPassword, String newPassword, String newPasswordSubmit) async {
    if (account!.password != oldPassword) {
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
    account!.password = newPassword;
    FirebaseUtils.setCollection('Accounts');
    await FirebaseUtils.auth.currentUser!.updatePassword(newPassword);
    FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).set(account!.toJson());
    FirebaseUtils.auth.signInWithEmailAndPassword(email: account!.password, password: account!.email).then((_) => AppUtils.showInfoMessage('Success', context));
  }

  void deleteAccount() {
    FirebaseUtils.setCollection('Accounts');
    FirebaseUtils.collection.doc(account!.id).delete();
    FirebaseUtils.auth.currentUser!.delete();
    AppUtils.switchScreen(const AuthScreen(), context);
  }

  void deleteFriend(String friendId) async {
    FirebaseUtils.setCollection('Accounts');
    Account friendAccount = Account.fromSnapshot(await FirebaseUtils.collection.doc(friendId).get());
    friendAccount.friends.remove(FirebaseUtils.auth.currentUser!.uid);
    account!.friends.remove(friendId);
    FirebaseUtils.collection.doc(friendId).set(friendAccount.toJson());
    FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).set(account!.toJson());
  }

  void signIn(String email, String password) async {
    try {
      await FirebaseUtils.auth.signInWithEmailAndPassword(email: email, password: password).then((_) => AppUtils.switchScreen(const HomeScreen(), context));
    } on FirebaseAuthException {
      AppUtils.showInfoMessage('Invalid email or password', context);
    }
  }

  void signOut() async {
    updateStatus(false);
    await FirebaseUtils.auth.signOut().then((user) => AppUtils.switchScreen(const AuthScreen(), context));
  }

  void _uploadFile(File image) async {
    String imageName = '${DateTime.now().millisecondsSinceEpoch}.jpeg';
    await FirebaseUtils.storage.ref().child(imageName).putFile(image);
    account!.image = imageName;
    FirebaseUtils.setCollection('Accounts');
    FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).set(account!.toJson());
  }
}
