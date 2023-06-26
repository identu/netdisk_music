import 'package:flutter/material.dart';
import 'package:netdisk_music/pages/music_list.dart';
import 'package:netdisk_music/pages/playlist_page.dart';
import 'home_music.dart';
import 'netdisk_music_page.dart';
//底栏作为父组件
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeMusic(),
    const MusicList(),
    const PlaylistPage(),
    const NetdiskMusicPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class FavouritePage {
}

class _CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      unselectedItemColor: Colors.green.shade200.withOpacity(0.8),
      selectedItemColor: const Color.fromRGBO(0, 117, 102, 1),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle),
          label: 'Playlist',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.favorite_outline),
        //   label: 'Favourite',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud),
          label: 'netdisk-music',
        ),
      ],
    );
  }
}
