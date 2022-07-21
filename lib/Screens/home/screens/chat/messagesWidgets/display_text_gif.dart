import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final String type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    return StatefulBuilder(builder: (context, setState) {
      return IconButton(
        constraints: const BoxConstraints(
          minWidth: 100,
        ),
        onPressed: () async {
          if (isPlaying) {
            await audioPlayer.pause();
            setState(() {
              isPlaying = false;
            });
          } else {
            await audioPlayer.play(UrlSource(message));
            setState(() {
              isPlaying = true;
            });
          }
        },
        icon: Icon(
          isPlaying ? Icons.pause_circle : Icons.play_circle,
        ),
      );
    });
  }
}