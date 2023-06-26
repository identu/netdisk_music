import 'dart:convert';

import 'package:flutter/material.dart';

import 'music_player.dart';

class MusicList extends StatefulWidget {
  const MusicList({Key? key}) : super(key: key);

  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  List<String> songs = [];

  String selectedSong = '';

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    // 从assets加载音乐列表
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;
    final songsPaths = manifestMap.keys
        .where((String key) => key.contains('local_music/'))
        .toList();
    setState(() {
      songs = songsPaths
          .map((String path) => path.replaceAll('assets/', ''))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
        child: Column(
          children: [
            AppBar(
              title: const Text('Music List'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Playing',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
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
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final songPath = songs[index];
                  final isSelected = song == selectedSong;

                  return ListTile(
                    title: Text(
                      song,
                      style: TextStyle(color: Colors.white),
                    ),
                    selected: isSelected,
                  onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => MusicPlayer(songPath: songPath),
                  ),
                  );

                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
