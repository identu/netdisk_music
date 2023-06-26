import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<String> songs = [
    'Song 1',
    'Song 2',
    'Song 3',
    'Song 4',
    'Song 5',
  ];

  String selectedSong = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final isSelected = song == selectedSong;

                return ListTile(
                  title: Text(song),
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedSong = song;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle play button action
              if (selectedSong.isNotEmpty) {
                // Play the selected song
                print('Playing $selectedSong');
              }
            },
            child: const Text('Play'),
          ),
        ],
      ),
    );
  }
}
