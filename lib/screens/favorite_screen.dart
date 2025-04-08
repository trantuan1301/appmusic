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
        title: Text('Danh sách yêu thích',style: TextStyle(color: Colors.purpleAccent),),
      ),
      body: favoriteSongs.isEmpty
          ? Center(child: Text('No favorite songs yet.'))
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