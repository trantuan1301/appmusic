part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlaySong extends PlayerEvent {
  final Song song;
  const PlaySong(this.song);
}

class PauseSong extends PlayerEvent {
  final Song song;
  const PauseSong(this.song);
}

class ResumeSong extends PlayerEvent {
  final Song song;
  const ResumeSong(this.song);
}

class NextSong extends PlayerEvent {}

class PreviousSong extends PlayerEvent {}

class ToggleShuffle extends PlayerEvent {}

class ChangeSpeed extends PlayerEvent {
  final double speed;
  const ChangeSpeed(this.speed);
}

class SeekSong extends PlayerEvent {
  final Duration position;
  const SeekSong(this.position);
}

class LoadSongs extends PlayerEvent {
  final List<Song> songs;
  LoadSongs(this.songs);
}


