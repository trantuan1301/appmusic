import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../blocs/player/player_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArtistSongsScreen extends StatelessWidget {
  final String artist;
  final List<Song> songs;

  ArtistSongsScreen({required this.artist, required this.songs});

  @override
  Widget build(BuildContext context) {
    final playerBloc = BlocProvider.of<PlayerBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Nghệ sĩ: $artist'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            title: Text(song.title),
            subtitle: Text(song.artist),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(song.imageUrl),
              child: Icon(Icons.music_note, color: Colors.white70),
            ),
            onTap: () {
              playerBloc.add(PlaySong(song));
            },
          );
        },
      ),
    );
  }
}