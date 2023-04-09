import '../models/account.dart';
import '../controllers/account_controller.dart';

import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

class ParticipantTile extends StatefulWidget {
  final Participant participant;
  final Account account;

  const ParticipantTile({super.key, required this.participant, required this.account});

  @override
  State<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile> {
  Stream? videoStream;

  @override
  void initState() {
    widget.participant.streams.forEach((key, Stream stream) {
      setState(() {
        if (stream.kind == 'video') {
          videoStream = stream;
        }
      });
    });
    _initStreamListeners();
    super.initState();
  }

  _initStreamListeners() {
    widget.participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => videoStream = stream);
      }
    });
    widget.participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => videoStream = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: videoStream != null
          ? Container(
              height: 200,
              width: 200,
              child: RTCVideoView(
                videoStream?.renderer as RTCVideoRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            )
          : Container(
              color: const Color.fromARGB(255, 22, 20, 32),
              child: FutureBuilder(
                future: AccountController.getAccountImageByName(widget.account.image),
                builder: (context, snapshotImage) {
                  return CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      snapshotImage.data.toString(),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
