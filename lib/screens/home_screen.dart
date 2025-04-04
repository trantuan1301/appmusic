import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/screens/profile_screen.dart';
import 'package:music_app/screens/songs_tab.dart';
import '../blocs/song/song_bloc.dart';
import '../blocs/player/player_bloc.dart';
import '../widgets/mini_player.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  bool isMiniPlayerVisible = true;
  int _currentIndex = 0;

  // Hiện mini player
  void showMiniPlayer() {
    if (!isMiniPlayerVisible) {
      setState(() {
        isMiniPlayerVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final songBloc = BlocProvider.of<SongBloc>(context);
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'Music Player' : _currentIndex == 1 ? "Favorites" : "Profile",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 24),
        ),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                setState(() {
                  _currentIndex = 1; // Chuyển sang Favorites tab
                });
              },
            ),
        ],
        // Chỉ hiện search khi ở tab bài hát
        bottom: _currentIndex == 0
            ? PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildSearchField(),
          ),
        )
            : null,
      ),
      // Nội dung từng tab
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SongsTab(
            searchQuery: searchQuery,
            onSongTap: () {
              showMiniPlayer();
              if (songBloc.state is SongLoaded) {
                playerBloc.add(PlayerLoadSong((songBloc.state as SongLoaded).songs)); // Load danh sách bài hát từ SongLoaded
              }
            },
          ), // Truyền search query vào tab bài hát
          FavoritesScreen(
            onSongTap: () {
              showMiniPlayer();
              if (songBloc.state is SongLoaded) {
                playerBloc.add(PlayerLoadSong((songBloc.state as SongLoaded).songs)); // Load danh sách bài hát từ SongLoaded
              }
            },
          ),
          ProfileScreen(),
        ],
      ),
      // Mini Player + Navigation bar
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMiniPlayerVisible)
            MiniPlayer(
              onSongTap: () => showMiniPlayer(),
            ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'Bài hát',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Yêu thích',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Cá nhân',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Tìm kiếm bài hát...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}