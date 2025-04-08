import 'package:flutter/material.dart';
import '../models/song_model.dart';
import 'artist_songs_screen.dart';

class ArtistScreen extends StatelessWidget {
  final List<Song> songs;

  ArtistScreen({required this.songs});

  @override
  Widget build(BuildContext context) {
    // Tạo một danh sách các nghệ sĩ từ danh sách bài hát
    final artists = songs.map((song) => song.artist).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách nghệ sĩ'),
      ),
      body: ListView.builder(
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return ListTile(
            title: Text(artist),
            onTap: () {
              // Chuyển đến trang danh sách bài hát của nghệ sĩ
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtistSongsScreen(
                    artist: artist,
                    songs: songs.where((song) => song.artist == artist).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}