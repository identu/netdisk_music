import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:netdisk_music/provider/music_play_provider.dart';

class MusicPlayer extends StatelessWidget {
  final String songPath;

  const MusicPlayer({Key? key, required this.songPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: Consumer<AudioPlayerProvider>(
        builder: (context, audioPlayerProvider, _) {
          final audioPlayerState = audioPlayerProvider.audioPlayerState;
          final currentPosition = audioPlayerProvider.currentPosition;
          final totalDuration = audioPlayerProvider.totalDuration;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Player State: $audioPlayerState',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Slider(
                value: currentPosition.inMilliseconds.toDouble(),
                min: 0.0,
                max: totalDuration.inMilliseconds.toDouble(),
                onChanged: (double value) {
                  final position = Duration(milliseconds: value.toInt());
                  audioPlayerProvider.audioPlayer.seek(position);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      audioPlayerProvider.playMusic(songPath);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () {
                      audioPlayerProvider.pauseMusic();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () {
                      audioPlayerProvider.stopMusic();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
