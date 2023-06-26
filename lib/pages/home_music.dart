
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomeMusic extends StatefulWidget {
  const HomeMusic({Key? key}) : super(key: key);

  @override
  _HomeMusicState createState() => _HomeMusicState();
}

class _HomeMusicState extends State<HomeMusic> {
  List<Song> songs = []; // 音乐列表
  Song? currentSong; // 当前播放的歌曲
  bool isPlaying = false; // 是否正在播放
  double progress = 0.0; // 音乐播放进度

  @override
  void initState() {
    super.initState();
    loadMusic();
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

  void playSong(Song song) {
    setState(() {
      currentSong = song;
      isPlaying = true;
      // 实现播放逻辑
    });
  }

  void pauseSong() {
    setState(() {
      isPlaying = false;
      // 实现暂停逻辑
    });
  }

  void playPreviousSong() {
    setState(() {
      // 实现上一曲逻辑
    });
  }

  void playNextSong() {
    setState(() {
      // 实现下一曲逻辑
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Music'),
      ),
      body: Stack(
        children: [

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
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
                        title: Text(song.name),
                        subtitle: Text(song.artist),
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
                            isSelected && isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}

class Song {
  final String name;
  final String artist;
  final String duration;

  Song({
    required this.name,
    required this.artist,
    required this.duration,
  });

  factory Song.fromFile(File file) {
    final filename = file.path.split('/').last;
    final parts = filename.split('-');
    final name = parts[0].trim();
    final artist = parts[1].trim();
    return Song(name: name, artist: artist, duration: 'Unknown');
  }
}
