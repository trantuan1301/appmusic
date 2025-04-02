// favorite_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/song_model.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState()) {
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
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
}
