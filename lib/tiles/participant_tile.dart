import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

import '../models/account.dart';

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

  void _initStreamListeners() {
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
          ? SizedBox(
              height: 200,
              width: 200,
              child: RTCVideoView(
                videoStream?.renderer as RTCVideoRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            )
          : Container(
              color: const Color.fromARGB(255, 22, 20, 32),
              child: const Icon(
                Icons.person,
                size: 100,
              ),
            ),
    );
  }
}
