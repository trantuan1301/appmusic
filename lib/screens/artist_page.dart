import 'package:flutter/material.dart';
import 'package:music_app/screens/artist_detail_page.dart';
import 'package:music_app/repositories/song_repository.dart';
import 'package:music_app/models/song_model.dart';

class ArtistPage extends StatelessWidget {
  final SongRepository songRepository = SongRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artists'),
      ),
      body: FutureBuilder<List<Song>>(
        future: songRepository.fetchSongsSortedByArtist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Song> songs = snapshot.data!;
            Map<String, List<Song>> artistMap = {};
            for (var song in songs) {
              if (!artistMap.containsKey(song.artist)) {
                artistMap[song.artist] = [];
              }
              artistMap[song.artist]!.add(song);
            }

            return ListView(
              children: artistMap.keys.map((artist) {
                return ListTile(
                  title: Text(artist),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtistDetailPage(artistName: artist, songs: artistMap[artist]!),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}