import 'dart:async';
import 'package:flutter/material.dart';

import '../models/account.dart';
import '../utils/firebase_utils.dart';
import '../models/friend_request.dart';
import '../controllers/account_controller.dart';

class FriendRequestController {
  BuildContext context;

  FriendRequestController({required this.context});

  void createFriendRequest(Account receiver) async {
    Account sender = await AccountController(context: context).getMyAccount().first;
    FirebaseUtils.setCollection('FriendRequests');
    FirebaseUtils.collection.add(FriendRequest(sender: sender.id!, receiver: receiver.id!).toJson());
  }

  static Stream<List<FriendRequest>> getFriendRequests() {
    FirebaseUtils.setCollection('FriendRequests');
    return FirebaseUtils.collection
        .where('receiver', isEqualTo: FirebaseUtils.auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FriendRequest.fromSnapshot(doc)).toList());
  }

  static Stream<Account> getAccountFromFriendRequest(FriendRequest friendRequest) {
    FirebaseUtils.setCollection('Accounts');
    return AccountController.getAccountById(friendRequest.receiver).asStream();
  }

  static void acceptFriendRequest(FriendRequest friendRequest) async {
    FirebaseUtils.setCollection('Accounts');
    Account myAccount = await AccountController.getAccountById(friendRequest.receiver);
    Account newFriendAccount = await AccountController.getAccountById(friendRequest.sender);
    myAccount.friends.add(friendRequest.sender);
    newFriendAccount.friends.add(friendRequest.receiver);
    FirebaseUtils.collection.doc(myAccount.id).set(myAccount.toJson());
    FirebaseUtils.collection.doc(newFriendAccount.id).set(newFriendAccount.toJson());
    FirebaseUtils.setCollection('FriendRequests');
    FirebaseUtils.collection.doc(friendRequest.id).delete();
  }

  static void deleteFriendRequest(FriendRequest friendRequest) {
    FirebaseUtils.setCollection('FriendRequests');
    FirebaseUtils.collection.doc(friendRequest.id).delete();
  }
}
