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
  late Song _currentSong;

  @override
  void initState() {
    super.initState();
    _currentSong = widget.songs.first; // Bài hát đầu tiên của nghệ sĩ
  }

  void showMiniPlayer() {
    if (!isMiniPlayerVisible) {
      setState(() {
        isMiniPlayerVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.artist)),
      body: BlocListener<PlayerBloc, PlayerState>(
        listener: (context, state) {
          if (state is PlayerPlaying) {
            // Kiểm tra xem bài hát hiện tại có thuộc danh sách bài hát của nghệ sĩ không
            if (widget.songs.contains(state.song)) {
              setState(() {
                _currentSong = state.song; // Cập nhật ảnh nghệ sĩ
              });
            }
          }
        },
        child: Column(
          children: [
            // Ảnh của nghệ sĩ
            Container(
              width: double.infinity,
              height: 450,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_currentSong.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.songs.length,
                itemBuilder: (context, index) {
                  final song = widget.songs[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(song.title),
                        subtitle: Text(song.artist),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(song.imageUrl),
                          backgroundColor: Colors.grey,
                          child:
                              song.imageUrl.isEmpty
                                  ? Icon(
                                    Icons.music_note,
                                    color: Colors.white70,
                                  )
                                  : null,
                        ),
                        onTap: () {
                          setState(() {
                            _currentSong = song;
                          });
                          playerBloc.add(PlayerLoadSong(widget.songs));
                          playerBloc.add(PlaySong(song));
                          showMiniPlayer();
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
            if (isMiniPlayerVisible)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ), // Dịch MiniPlayer lên 10 pixel
                child: MiniPlayer(onSongTap: () => showMiniPlayer()),
              ),
          ],
        ),
      ),
    );
  }
}
