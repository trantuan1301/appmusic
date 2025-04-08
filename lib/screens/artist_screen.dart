import 'package:flutter/material.dart';
import '../models/song_model.dart';
import 'artist_songs_screen.dart';

class ArtistScreen extends StatefulWidget {
  final List<Song> songs;

  ArtistScreen({required this.songs});

  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> _artists = [];
  List<String> _filteredArtists = [];

  @override
  void initState() {
    super.initState();

    _artists = widget.songs.map((song) => song.artist).toSet().toList();
    _filteredArtists = _artists;
  }

  void _filterArtists(String query) {
    setState(() {
      _filteredArtists = _artists
          .where((artist) => artist.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách nghệ sĩ',style: TextStyle(color: Colors.purpleAccent),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm nghệ sĩ',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterArtists,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredArtists.length,
              itemBuilder: (context, index) {
                final artist = _filteredArtists[index];
                final artistSongs = widget.songs
                    .where((song) => song.artist == artist)
                    .toList();
                final firstSongImageUrl = artistSongs.isNotEmpty
                    ? artistSongs.first.imageUrl
                    : '';

                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: firstSongImageUrl.isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(firstSongImageUrl),
                            fit: BoxFit.cover,
                          )
                              : null,
                          color: Colors.grey,
                        ),
                        child: firstSongImageUrl.isEmpty
                            ? Icon(Icons.person, color: Colors.white70)
                            : null,
                      ),
                      title: Text(artist),
                      onTap: () {
                        // Chuyển đến trang danh sách bài hát của nghệ sĩ
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtistSongsScreen(
                              artist: artist,
                              songs: artistSongs,
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(), // Thêm gạch ngang dưới mỗi nghệ sĩ
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}