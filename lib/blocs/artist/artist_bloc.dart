import 'package:flutter_bloc/flutter_bloc.dart';
import 'artist_event.dart';
import 'artist_state.dart';
import '../../models/song_model.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final List<Song> allSongs;

  ArtistBloc({required this.allSongs}) : super(ArtistInitial()) {
    on<LoadArtists>(_onLoadArtists);
    on<SelectArtist>(_onSelectArtist);
  }

  void _onLoadArtists(LoadArtists event, Emitter<ArtistState> emit) {
    final artists = allSongs.map((song) => song.artist).toSet().toList();
    emit(ArtistsLoaded(artists: artists));
  }

  void _onSelectArtist(SelectArtist event, Emitter<ArtistState> emit) {
    final artistSongs = allSongs.where((song) => song.artist == event.artist).toList();
    emit(ArtistSongsLoaded(artist: event.artist, songs: artistSongs));
  }
}