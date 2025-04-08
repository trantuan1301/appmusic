import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../blocs/player/player_bloc.dart';
import '../blocs/song/song_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/mini_player.dart';
import 'home_screen.dart';
import 'favorite_screen.dart';
import 'profile_screen.dart';
import 'artist_screen.dart';

class ArtistSongsScreen extends StatefulWidget {
  final String artist;
  final List<Song> songs;

  ArtistSongsScreen({required this.artist, required this.songs});

  @override
  _ArtistSongsScreenState createState() => _ArtistSongsScreenState();
}

class _ArtistSongsScreenState extends State<ArtistSongsScreen> {
  bool isMiniPlayerVisible = true;
  int _currentIndex = 0;

  void showMiniPlayer() {
    if (!isMiniPlayerVisible) {
      setState(() {
        isMiniPlayerVisible = true;
      });
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(onThemeChanged: (bool value) {})),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FavoritesScreen(
            onSongTap: () {
              showMiniPlayer();
              final songBloc = BlocProvider.of<SongBloc>(context);
              final playerBloc = BlocProvider.of<PlayerBloc>(context);
              if (songBloc.state is SongLoaded) {
                playerBloc.add(
                  PlayerLoadSong((songBloc.state as SongLoaded).songs),
                );
              }
            },
          )),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(onThemeChanged: (bool value) {})),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ArtistScreen(
            songs: widget.songs,
          )),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.artist}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.songs.length,
              itemBuilder: (context, index) {
                final song = widget.songs[index];
                return ListTile(
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.imageUrl),
                    child: Icon(Icons.music_note, color: Colors.white70),
                  ),
                  onTap: () {
                    playerBloc.add(PlayerLoadSong(widget.songs));
                    playerBloc.add(PlaySong(song));
                    showMiniPlayer();
                  },
                );
              },
            ),
          ),
          if (isMiniPlayerVisible)
            MiniPlayer(onSongTap: () => showMiniPlayer()),
        ],
      ),
    );
  }
}