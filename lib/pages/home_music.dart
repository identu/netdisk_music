import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeMusic extends StatefulWidget {
  const HomeMusic({Key? key}) : super(key: key);

  @override
  _HomeMusicState createState() => _HomeMusicState();
}

class _HomeMusicState extends State<HomeMusic> {
  List<Song> songs = []; // 音乐列表
  Song? currentSong; // 当前播放的歌曲
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false; // 是否正在播放
  double progress = 0.0; // 音乐播放进度
  int currentIndex = 0; // 当前播放的歌曲索引

  @override
  void initState() {
    super.initState();
    loadMusic();
  }

  @override
  void dispose() {
    audioPlayer.stop(); // 停止音乐播放
    audioPlayer.dispose(); // 释放资源
    super.dispose();
  }

  Future<void> loadMusic() async {
    final musicDirectory = Directory('assets/local_music');
    final files = await musicDirectory.list().toList();

    songs = files
        .where((file) => file.path.endsWith('.ogg'))
        .map((file) => Song.fromFile(File(file.path)))
        .toList();

    print('Number of songs: ${songs.length}');

    setState(() {});
  }

  Future<void> playSong(Song song) async {
    final songPath = 'local_music/${song.artist} - ${song.name}';

    await audioPlayer.play(AssetSource(songPath));

    setState(() {
      currentSong = song;
      isPlaying = true;
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      // 获取音乐的总时长
      setState(() {
        currentSong?.duration = duration;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      // 获取音乐的当前播放进度
      setState(() {
        progress = position.inMilliseconds.toDouble();
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      // 歌曲播放完成后自动播放下一首
      playNextSong();
    });
  }

  void pauseSong() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void resumeSong() async {
    await audioPlayer.resume();
    setState(() {
      isPlaying = true;
    });
  }

  void stopSong() async {
    await audioPlayer.stop();
    setState(() {
      currentSong = null;
      isPlaying = false;
      progress = 0.0;
    });
  }

  void playPreviousSong() {
    final newIndex = currentIndex - 1;
    if (newIndex >= 0) {
      final previousSong = songs[newIndex];
      playSong(previousSong);
      setState(() {
        currentIndex = newIndex;
      });
    }
  }

  void playNextSong() {
    final newIndex = currentIndex + 1;
    if (newIndex < songs.length) {
      final nextSong = songs[newIndex];
      playSong(nextSong);
      setState(() {
        currentIndex = newIndex;
      });
    } else {
      // 如果已经是最后一首歌曲，则停止播放
      stopSong();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.shade800.withOpacity(0.8),
            Colors.black12.withOpacity(0.6),
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Music'),
          backgroundColor: Colors.transparent,
          // Set app bar background color to transparent
          elevation: 0, // Remove app bar elevation
        ),
        backgroundColor: Colors.transparent,
        // Set scaffold background color to transparent
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white38,
                      hintText: 'Search now...',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.black12),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        final isSelected = song == currentSong;

                        return ListTile(
                          title: Text(song.name,style:const TextStyle(color: Colors.white)),
                          subtitle: Text(song.artist,style:const TextStyle(color: Colors.white)),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                if (isSelected && isPlaying) {
                                  pauseSong();
                                } else {
                                  playSong(song);
                                }
                              });
                            },
                            icon: Icon(
                              isSelected && isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (currentSong != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        currentSong!.name,
                        style: TextStyle(
                            color: Colors.black), // Set font color to black
                      ),
                      Text(
                        currentSong!.artist,
                        style: TextStyle(
                            color: Colors.black), // Set font color to black
                      ),
                      Slider(
                        value: progress,
                        min: 0.0,
                        max: currentSong!.duration?.inMilliseconds.toDouble() ??
                            0.0,
                        onChanged: (value) {
                          // 设置音乐播放进度
                          audioPlayer
                              .seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => stopSong(),
                            icon: Icon(Icons.stop),
                          ),
                          IconButton(
                            onPressed: () {
                              if (isPlaying) {
                                pauseSong();
                              } else {
                                resumeSong();
                              }
                            },
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Song {
  final String name;
  final String artist;
  Duration? duration;

  Song({
    required this.name,
    required this.artist,
    this.duration,
  });

  factory Song.fromFile(File file) {
    final filename = file.path.split('/').last;
    final parts = filename.split(' - ');
    final artist = parts[0].trim();
    final name = parts[1].trim();
    return Song(name: name, artist: artist);
  }
}
