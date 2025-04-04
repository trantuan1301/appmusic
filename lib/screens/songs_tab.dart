import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/song/song_bloc.dart';
import '../widgets/song_tile.dart';

class SongsTab extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onSongTap;

  const SongsTab({Key? key, this.searchQuery = '', required this.onSongTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songBloc = BlocProvider.of<SongBloc>(context);

    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SongLoaded) {
          final songs = state.songs;

          // Lọc theo searchQuery
          final filteredSongs = songs
              .where((song) => song.title
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
              .toList();

          if (filteredSongs.isEmpty) {
            return Center(child: Text('Không tìm thấy bài hát nào.'));
          }

          return ListView.builder(
            itemCount: filteredSongs.length,
            itemBuilder: (context, index) {
              final song = filteredSongs[index];
              return SongTile(song: song, onSongTap: onSongTap,);
            },
          );
        } else {
          return Center(child: Text('Đã xảy ra lỗi.'));
        }
      },
    );
  }
}
