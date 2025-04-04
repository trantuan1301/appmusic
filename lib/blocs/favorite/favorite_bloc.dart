import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/song_model.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';
import '../player/player_bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final PlayerBloc playerBloc;

  FavoriteBloc(this.playerBloc) : super(const FavoriteState()) {
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<PlayFavorite>(_onPlayFavorite); // Thêm sự kiện PlayFavorite
  }

  void _onAddFavorite(AddFavorite event, Emitter<FavoriteState> emit) {
    final updatedFavorites = List<Song>.from(state.favorites)..add(event.song);
    emit(state.copyWith(favorites: updatedFavorites));
  }

  void _onRemoveFavorite(RemoveFavorite event, Emitter<FavoriteState> emit) {
    final updatedFavorites = List<Song>.from(state.favorites)
      ..removeWhere((song) => song.id == event.song.id);
    emit(state.copyWith(favorites: updatedFavorites));
  }

  void _onPlayFavorite(PlayFavorite event, Emitter<FavoriteState> emit) {
    playerBloc.add(PlayerLoadSong(state.favorites));
    playerBloc.add(PlaySong(event.song));
  }
}