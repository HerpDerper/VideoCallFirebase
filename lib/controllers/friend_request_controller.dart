import 'package:flutter/material.dart';
import 'package:flutter_video_call/controllers/account_controller.dart';

import '../models/account.dart';
import '../utils/app_utils.dart';
import '../utils/firebase_utils.dart';
import '../models/friend_request.dart';

class FriendRequestController {
  FriendRequest? friendRequest;
  BuildContext context;

  FriendRequestController({required this.context, this.friendRequest});

  void createFriendRequest(Account receiver) {
    Account sender = AccountController(context: context).account!;
    FirebaseUtils.setCollection('FriendRequests');
    FirebaseUtils.collection.add(FriendRequest(sender: sender.id!, receiver: receiver.id!).toJson());
    AppUtils.showInfoMessage('Request was send', context);
  }

  // Stream<List<FriendRequest>> getFriendRequest() {
  //   FirebaseUtils.setCollection('FriendRequests');
  //   return FirebaseUtils.collection.doc(FirebaseUtils.auth.currentUser!.uid).snapshots().map((snapshot) => FriendRequest.fromSnapshot(snapshot));
  // }
}
