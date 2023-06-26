import 'package:flutter/material.dart';
import 'my_favorite_page.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<String> playlists = [
    '我的喜欢',
    '我的收藏',
    '常听歌曲',
  ];

  String selectedPlaylist = '';

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
          title: const Text('歌单列表'),
          backgroundColor: Colors.transparent,
          // Set app bar background color to transparent
          elevation: 0, // Remove app bar elevation
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  final isSelected = playlist == selectedPlaylist;

                  return ListTile(
                    title: Text(playlist),
                    textColor: Colors.white70,
                    selected: isSelected,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyFavoritePage(playlist: playlist)),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 66.0), // Adjust the bottom padding as per your needs
              child: OutlinedButton(
                style: const ButtonStyle(
                  foregroundColor:
                      MaterialStatePropertyAll<Color>(Colors.white),
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.black38),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String newPlaylistName = '';

                      return AlertDialog(
                        title: const Text('创建歌单'),
                        content: TextField(
                          onChanged: (value) {
                            newPlaylistName = value;
                          },
                          decoration: const InputDecoration(hintText: '输入歌单名称'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (newPlaylistName.isNotEmpty) {
                                setState(() {
                                  playlists.add(newPlaylistName);
                                  selectedPlaylist = newPlaylistName;
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('创建'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('取消'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('创建歌单'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
