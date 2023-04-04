import 'package:flutter/material.dart';

import '../models/account.dart';
import '../utils/firebase_utils.dart';
import '../models/friend_request.dart';
import '../controllers/account_controller.dart';

class FriendRequestController {
  FriendRequest? friendRequest;
  BuildContext context;

  FriendRequestController({required this.context, this.friendRequest});

  void createFriendRequest(Account receiver) async {
    Account sender = await AccountController(context: context).getMyAccount().first;
    FirebaseUtils.setCollection('FriendRequests');
    FirebaseUtils.collection.add(FriendRequest(sender: sender.id!, receiver: receiver.id!).toJson());
  }

  Stream<List<Account>> getFriendRequest() {
    return FirebaseUtils.collection.snapshots().map((snapshot) => snapshot.docs.map((doc) => Account.fromSnapshot(doc)).toList());
  }
}
