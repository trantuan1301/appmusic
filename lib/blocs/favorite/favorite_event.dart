import '../../models/song_model.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class AddFavorite extends FavoriteEvent {
  final Song song;

  const AddFavorite(this.song);

  @override
  List<Object?> get props => [song];
}

class RemoveFavorite extends FavoriteEvent {
  final Song song;

  const RemoveFavorite(this.song);

  @override
  List<Object?> get props => [song];
}

class PlayFavorite extends FavoriteEvent {
  final Song song;

  const PlayFavorite(this.song);

  @override
  List<Object?> get props => [song];
}