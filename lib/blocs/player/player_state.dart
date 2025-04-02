part of 'player_bloc.dart';

abstract class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object?> get props => [];
}

class PlayerStopped extends PlayerState {}

class PlayerPlaying extends PlayerState {
  final Song song;
  final bool isShuffling;
  final double speed;
  final Duration position;
  final Duration duration;

  const PlayerPlaying({
    required this.song,
    this.isShuffling = false,
    this.speed = 1.0,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  @override
  List<Object?> get props => [song, isShuffling, speed, position, duration];
}

class PlayerPaused extends PlayerState {
  final Song song;

  PlayerPaused(this.song);

  @override
  List<Object?> get props => [song];
}

class PlayerLoadSong extends PlayerEvent {
  final List<Song> songs;

  const PlayerLoadSong(this.songs);

  @override
  List<Object?> get props => [songs];
}
