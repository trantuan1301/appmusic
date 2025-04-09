import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/favorite/favorite_bloc.dart';
import '../blocs/favorite/favorite_event.dart';
import '../widgets/song_tile.dart';

class FavoritesScreen extends StatelessWidget {
  final VoidCallback onSongTap;
  const FavoritesScreen({Key? key, required this.onSongTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteBloc = context.watch<FavoriteBloc>();
    final favoriteSongs = favoriteBloc.state.favorites;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Danh sách yêu thích',
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body:
          favoriteSongs.isEmpty
              ? Center(
                child: Text(
                  'Bạn chưa yêu thích bài hát nào!',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: favoriteSongs.length,
                itemBuilder: (context, index) {
                  final song = favoriteSongs[index];
                  return SongTile(
                    song: song,
                    onSongTap: () {
                      context.read<FavoriteBloc>().add(PlayFavorite(song));
                      onSongTap();
                    },
                  );
                },
              ),
    );
  }
}
