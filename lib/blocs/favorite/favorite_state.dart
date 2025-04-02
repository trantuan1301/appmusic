// favorite_state.dart
import 'package:equatable/equatable.dart';
import '../../models/song_model.dart';
class FavoriteState extends Equatable {
  final List<Song> favorites;

  const FavoriteState({this.favorites = const []});

  FavoriteState copyWith({List<Song>? favorites}) {
    return FavoriteState(
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [favorites];
}