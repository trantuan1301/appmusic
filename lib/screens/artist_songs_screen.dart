import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../blocs/player/player_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/mini_player.dart';

class ArtistSongsScreen extends StatefulWidget {
  final String artist;
  final List<Song> songs;

  const ArtistSongsScreen({required this.artist, required this.songs});

  @override
  _ArtistSongsScreenState createState() => _ArtistSongsScreenState();
}

class _ArtistSongsScreenState extends State<ArtistSongsScreen> {
  bool isMiniPlayerVisible = true;
  late Song _currentSong;

  @override
  void initState() {
    super.initState();
    _currentSong = widget.songs.first;
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          widget.artist,
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: BackButton(color: Colors.purpleAccent),
      ),
      body: BlocListener<PlayerBloc, PlayerState>(
        listener: (context, state) {
          if (state is PlayerPlaying && widget.songs.contains(state.song)) {
            setState(() => _currentSong = state.song);
          }
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _currentSong.imageUrl,
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(
                'Danh sách bài hát',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: widget.songs.length,
                itemBuilder: (context, index) {
                  final song = widget.songs[index];
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(song.imageUrl),
                          backgroundColor: Colors.grey[300],
                          child:
                              song.imageUrl.isEmpty
                                  ? Icon(Icons.music_note, color: Colors.white)
                                  : null,
                        ),
                        title: Text(
                          song.title,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(song.artist),
                        onTap: () {
                          setState(() => _currentSong = song);
                          playerBloc.add(PlayerLoadSong(widget.songs));
                          playerBloc.add(PlaySong(song));
                          showMiniPlayer();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(height: 1, color: Colors.grey[300]),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          isMiniPlayerVisible
              ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MiniPlayer(onSongTap: showMiniPlayer),
              )
              : null,
    );
  }
}
