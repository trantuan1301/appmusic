import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/widgets/mini_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/blocs/player/player_bloc.dart';

class ArtistDetailPage extends StatefulWidget {
  final String artistName;
  final List<Song> songs;

  ArtistDetailPage({required this.artistName, required this.songs});

  @override
  _ArtistDetailPageState createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  late AudioPlayer _audioPlayer;
  bool isMiniPlayerVisible = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSong(Song song) async {
    try {
      await _audioPlayer.setUrl(song.songUrl);
      _audioPlayer.play();
      context.read<PlayerBloc>().add(PlaySong(song)); // Chỉ truyền một đối số
      setState(() {
        isMiniPlayerVisible = true;
      });
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artistName),
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
                  onTap: () {
                    _playSong(song); // Phát nhạc khi bấm vào bài hát
                  },
                );
              },
            ),
          ),
          if (isMiniPlayerVisible)
            MiniPlayer(
              onSongTap: () {
                // Chỉ hiển thị MiniPlayer mà không cần chuyển hướng
              },
            ),
        ],
      ),
    );
  }
}