import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

import '../utils/agora_utils.dart';

class VideoScreen extends StatefulWidget {
  final String channelName, userName;

  const VideoScreen({super.key, required this.channelName, required this.userName});

  @override
  State<VideoScreen> createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  bool isInitialized = false;

  void _endCall() => Navigator.pop(context);

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    AgoraUtils.setChannel(widget.channelName);
    await AgoraUtils.agoraClient.initialize().then((value) => setState(() => isInitialized = true));
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 38, 35, 55),
        body: Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 123, 118, 155),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 38, 35, 55),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 22, 20, 32),
          title: Text(widget.userName),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            AgoraVideoViewer(
              client: AgoraUtils.agoraClient,
            ),
            AgoraVideoButtons(
              disconnectButtonChild: RawMaterialButton(
                onPressed: () => _endCall(),
                shape: const CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.redAccent,
                padding: const EdgeInsets.all(15.0),
                child: const Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 35.0,
                ),
              ),
              client: AgoraUtils.agoraClient,
            ),
          ],
        ),
      );
    }
  }
}
