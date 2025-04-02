part of 'song_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object?> get props => [];
}

class FetchSongs extends SongEvent {}

class ToggleFavorite extends SongEvent {
  final Song song;

  ToggleFavorite(this.song);
}

class SearchSongs extends SongEvent {
  final String query;

  SearchSongs(this.query);
}

