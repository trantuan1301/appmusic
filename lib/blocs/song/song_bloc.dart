import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/song_model.dart';
import '../../repositories/song_repository.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final SongRepository songRepository;

  SongBloc(this.songRepository) : super(SongInitial()) {
    on<FetchSongs>(_onFetchSongs);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SearchSongs>(_onSearchSongs);
  }

  void _onFetchSongs(FetchSongs event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      final songs = await songRepository.fetchSongs();
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError('Failed to load songs'));
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<SongState> emit) {
    if (state is SongLoaded) {
      final currentState = state as SongLoaded;
      final updatedSongs =
          currentState.songs.map((song) {
            if (song.id == event.song.id) {
              song.isFavorite = !song.isFavorite;
            }
            return song;
          }).toList();
      emit(SongLoaded(updatedSongs));
    }
  }

  void _onSearchSongs(SearchSongs event, Emitter<SongState> emit) {
    if (state is SongLoaded) {
      final currentState = state as SongLoaded;
      final filteredSongs =
          currentState.songs
              .where(
                (song) => song.title.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
              )
              .toList();
      emit(SongLoaded(filteredSongs));
    }
  }
}
