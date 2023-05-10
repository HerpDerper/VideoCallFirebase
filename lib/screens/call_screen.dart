import 'package:flutter/material.dart';
import "package:videosdk/videosdk.dart";

import '../models/account.dart';
import '../utils/video_sdk_utils.dart';
import '../tiles/participant_tile.dart';

class CallScreen extends StatefulWidget {
  final String meetingId;
  final Account account;

  const CallScreen({super.key, required this.meetingId, required this.account});

  @override
  State<CallScreen> createState() => CallScreenState();
}

class CallScreenState extends State<CallScreen> {
  late Room currentRoom;
  late List<bool> expandableState;
  Map<String, Participant> participants = {};
  bool micEnabled = false;
  bool camEnabled = false;

  @override
  void initState() {
    currentRoom = VideoSDK.createRoom(
        roomId: widget.meetingId, token: token, displayName: widget.account.userName, micEnabled: micEnabled, camEnabled: camEnabled, defaultCameraIndex: 1);
    _setMeetingEventListener();
    currentRoom.join();
    expandableState = List.generate(1, (index) => false);
    super.initState();
  }

  void _setMeetingEventListener() {
    currentRoom.on(Events.roomJoined, () => setState(() => participants[currentRoom.localParticipant.id] = currentRoom.localParticipant));
    currentRoom.on(Events.participantJoined, (Participant participant) => setState(() => participants[participant.id] = participant));
    currentRoom.on(Events.participantLeft, (String participantId) {
      if (participants.containsKey(participantId)) {
        setState(() => participants.remove(participantId));
      }
    });
    currentRoom.on(Events.roomLeft, () {
      participants.clear();
      Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }

  Future<bool> _onWillPop() async {
    currentRoom.leave();
    return true;
  }

  Widget _flexableItem(double width, int index) {
    bool isExpanded = expandableState[index];
    return GestureDetector(
      onTap: () => setState(() => expandableState[index] = !isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: !isExpanded ? width * 0.6 : width * 1.2,
        height: !isExpanded ? width * 0.6 : width * 1.2,
        child: ParticipantTile(
          participant: participants.values.elementAt(index),
          account: widget.account,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 38, 35, 55),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 12, 17),
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'VideoCall',
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ParticipantTile(participant: participants.values.elementAt(index), account: widget.account);
                },
                itemCount: participants.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      micEnabled ? currentRoom.muteMic() : currentRoom.unmuteMic();
                      setState(() => micEnabled = !micEnabled);
                    },
                    shape: const CircleBorder(),
                    elevation: 2,
                    fillColor: micEnabled ? Colors.deepPurple : Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      micEnabled ? Icons.mic : Icons.mic_off,
                      color: micEnabled ? Colors.white : Colors.deepPurple,
                      size: 20,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () => currentRoom.leave(),
                    shape: const CircleBorder(),
                    elevation: 2,
                    fillColor: Colors.redAccent,
                    padding: const EdgeInsets.all(15),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      camEnabled ? currentRoom.disableCam() : currentRoom.enableCam();
                      setState(() => camEnabled = !camEnabled);
                    },
                    shape: const CircleBorder(),
                    elevation: 2,
                    fillColor: camEnabled ? Colors.deepPurple : Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      camEnabled ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                      color: camEnabled ? Colors.white : Colors.deepPurple,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
