import 'package:flutter/material.dart';
import '../models/song_model.dart';
import 'artist_songs_screen.dart';

class ArtistScreen extends StatefulWidget {
  final List<Song> songs;

  const ArtistScreen({required this.songs});

  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _artists;
  late List<String> _filteredArtists;

  @override
  void initState() {
    super.initState();
    _artists = widget.songs.map((song) => song.artist).toSet().toList();
    _filteredArtists = _artists;
  }

  void _filterArtists(String query) {
    setState(() {
      _filteredArtists =
          _artists
              .where(
                (artist) => artist.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Danh sách nghệ sĩ',
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm nghệ sĩ',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: _filterArtists,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredArtists.length,
              separatorBuilder:
                  (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[300],
                    indent: 16,
                    endIndent: 16,
                  ),
              itemBuilder: (context, index) {
                final artist = _filteredArtists[index];
                final artistSongs =
                    widget.songs
                        .where((song) => song.artist == artist)
                        .toList();
                final firstSongImageUrl =
                    artistSongs.isNotEmpty ? artistSongs.first.imageUrl : '';

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child:
                          firstSongImageUrl.isNotEmpty
                              ? Image.network(
                                firstSongImageUrl,
                                fit: BoxFit.cover,
                              )
                              : Icon(Icons.person, color: Colors.white70),
                    ),
                  ),
                  title: Text(
                    artist,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ArtistSongsScreen(
                              artist: artist,
                              songs: artistSongs,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
