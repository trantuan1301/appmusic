import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/screens/profile_screen.dart';
import 'package:music_app/screens/songs_tab.dart';
import '../blocs/song/song_bloc.dart';
import '../blocs/player/player_bloc.dart';
import '../widgets/mini_player.dart';
import 'favorite_screen.dart';
import 'artist_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const HomeScreen({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  bool isMiniPlayerVisible = true;
  int _currentIndex = 0;

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          _currentIndex == 0
              ? '🎵 VPOP MUSIC'
              : _currentIndex == 1
              ? "❤️ Favorites"
              : _currentIndex == 2
              ? "🎤 Artist"
              : "👤 Profile",
          style: TextStyle(
            color: Colors.purpleAccent,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        bottom: _currentIndex == 0
            ? PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchField(),
                SizedBox(height: 8),
                Text(
                  '🎧 Playlist',
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        )
            : null,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SongsTab(
            searchQuery: searchQuery,
            onSongTap: () {
              showMiniPlayer();
              if (songBloc.state is SongLoaded) {
                playerBloc.add(
                  PlayerLoadSong((songBloc.state as SongLoaded).songs),
                );
              }
            },
          ),
          FavoritesScreen(
            onSongTap: () {
              showMiniPlayer();
              if (songBloc.state is SongLoaded) {
                playerBloc.add(
                  PlayerLoadSong((songBloc.state as SongLoaded).songs),
                );
              }
            },
          ),
          if (songBloc.state is SongLoaded)
            ArtistScreen(songs: (songBloc.state as SongLoaded).songs)
          else
            Center(child: CircularProgressIndicator()),
          ProfileScreen(onThemeChanged: widget.onThemeChanged),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMiniPlayerVisible)
            MiniPlayer(onSongTap: () => showMiniPlayer()),
          BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.purpleAccent,
            unselectedItemColor: Colors.grey,
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
                  icon: Icon(Icons.mic),
                  label: 'Nghệ sĩ'
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          labelText: 'Tìm kiếm bài hát',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}