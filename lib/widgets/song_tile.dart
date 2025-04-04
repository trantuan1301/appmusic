import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/favorite/favorite_bloc.dart';
import '../blocs/favorite/favorite_event.dart';
import '../blocs/favorite/favorite_state.dart';
import '../models/song_model.dart';
import '../blocs/player/player_bloc.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback onSongTap;

  const SongTile({Key? key, required this.song, required this.onSongTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bloc để quản lý danh sách bài hát yêu thích
    final favoriteBloc = context.read<FavoriteBloc>();

    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favoriteState) {
        // Kiểm tra bài hát có trong danh sách yêu thích không
        final isFavorite = favoriteState.favorites.contains(song);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(song.imageUrl),
            child: Icon(Icons.music_note, color: Colors.white70),
          ),
          title: Text(song.title),
          subtitle: Text(song.artist),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              if (isFavorite) {
                favoriteBloc.add(RemoveFavorite(song));
              } else {
                favoriteBloc.add(AddFavorite(song));
              }
            },
          ),
          onTap: () {
            onSongTap();
            context.read<PlayerBloc>().add(PlaySong(song));
            print('Bài hát: ${song.title}');
          },
        );
      },
    );
  }
}
