import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:equatable/equatable.dart';
import '../../models/song_model.dart';
part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Song> playlist = [];
  int currentSongIndex = 0;
  bool isShuffling = false;
  double playbackSpeed = 1.0;

  PlayerBloc() : super(PlayerStopped()) {
    on<PlaySong>(_onPlaySong);
    on<PauseSong>(_onPauseSong);
    on<ResumeSong>(_onResumeSong);
    on<NextSong>(_onNextSong);
    on<PreviousSong>(_onPreviousSong);
    on<ToggleShuffle>(_onToggleShuffle);
    on<ChangeSpeed>(_onChangeSpeed);
    on<SeekSong>(_onSeekSong);
    on<PlayerLoadSong>(_onLoadSongs);

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _handleSongComplete();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      if (state is PlayerPlaying) {
        final current = state as PlayerPlaying;
        emit(PlayerPlaying(
          song: current.song,
          isShuffling: isShuffling,
          speed: playbackSpeed,
          position: position,
          duration: _audioPlayer.duration ?? Duration.zero,
        ));
      }
    });
  }

  Future<void> _onLoadSongs(PlayerLoadSong event, Emitter<PlayerState> emit) async {
    playlist.clear();
    playlist.addAll(event.songs);
    currentSongIndex = 0; // reset index hoặc logic khác tùy ý bạn
  }

  Future<void> _onPlaySong(PlaySong event, Emitter<PlayerState> emit) async {
    currentSongIndex = playlist.indexOf(event.song);
    try {
      await _audioPlayer.setUrl(event.song.songUrl);
      _audioPlayer.setSpeed(playbackSpeed);
      _audioPlayer.play();
      emit(PlayerPlaying(
        song: event.song,
        isShuffling: isShuffling,
        speed: playbackSpeed,
        position: Duration.zero,
        duration: _audioPlayer.duration ?? Duration.zero,
      ));
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> _onPauseSong(PauseSong event, Emitter<PlayerState> emit) async {
    await _audioPlayer.pause();
    emit(PlayerPaused(event.song));
  }

  Future<void> _onResumeSong(ResumeSong event, Emitter<PlayerState> emit) async {
    _audioPlayer.play();
    emit(PlayerPlaying(
      song: event.song,
      isShuffling: isShuffling,
      speed: playbackSpeed,
      position: _audioPlayer.position,
      duration: _audioPlayer.duration ?? Duration.zero,
    ));
  }

  Future<void> _onNextSong(NextSong event, Emitter<PlayerState> emit) async {
    if (playlist.isEmpty) return;

    if (isShuffling) {
      currentSongIndex = (currentSongIndex + 1 + (playlist.length - 1)) % playlist.length;
      currentSongIndex = _getRandomIndex(exclude: currentSongIndex);
    } else {
      currentSongIndex = (currentSongIndex + 1) % playlist.length;
    }

    final nextSong = playlist[currentSongIndex];
    add(PlaySong(nextSong));
  }

  Future<void> _onPreviousSong(PreviousSong event, Emitter<PlayerState> emit) async {
    if (playlist.isEmpty) return;

    currentSongIndex = (currentSongIndex - 1 + playlist.length) % playlist.length;
    final previousSong = playlist[currentSongIndex];
    add(PlaySong(previousSong));
  }

  Future<void> _onToggleShuffle(ToggleShuffle event, Emitter<PlayerState> emit) async {
    isShuffling = !isShuffling;

    if (state is PlayerPlaying) {
      final current = state as PlayerPlaying;
      emit(PlayerPlaying(
        song: current.song,
        isShuffling: isShuffling,
        speed: playbackSpeed,
        position: _audioPlayer.position,
        duration: _audioPlayer.duration ?? Duration.zero,
      ));
    }
  }

  Future<void> _onChangeSpeed(ChangeSpeed event, Emitter<PlayerState> emit) async {
    playbackSpeed = event.speed;
    await _audioPlayer.setSpeed(playbackSpeed);

    if (state is PlayerPlaying) {
      final current = state as PlayerPlaying;
      emit(PlayerPlaying(
        song: current.song,
        isShuffling: isShuffling,
        speed: playbackSpeed,
        position: _audioPlayer.position,
        duration: _audioPlayer.duration ?? Duration.zero,
      ));
    }
  }

  Future<void> _onSeekSong(SeekSong event, Emitter<PlayerState> emit) async {
    await _audioPlayer.seek(event.position);

    if (state is PlayerPlaying) {
      final current = state as PlayerPlaying;
      emit(PlayerPlaying(
        song: current.song,
        isShuffling: isShuffling,
        speed: playbackSpeed,
        position: event.position,
        duration: _audioPlayer.duration ?? Duration.zero,
      ));
    }
  }

  void _handleSongComplete() {
    if (playlist.isEmpty) return;

    if (isShuffling) {
      currentSongIndex = _getRandomIndex(exclude: currentSongIndex);
    } else {
      currentSongIndex = (currentSongIndex + 1) % playlist.length;
    }

    final nextSong = playlist[currentSongIndex];
    add(PlaySong(nextSong));
  }

  int _getRandomIndex({required int exclude}) {
    final random = playlist.toList()..removeAt(exclude);
    random.shuffle();
    return playlist.indexOf(random.first);
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }

  AudioPlayer get audioPlayer => _audioPlayer;
}