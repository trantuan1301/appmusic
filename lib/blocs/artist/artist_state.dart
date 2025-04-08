import 'package:equatable/equatable.dart';
import '../../models/song_model.dart';

abstract class ArtistState extends Equatable {
  @override
  List<Object> get props => [];
}

class ArtistInitial extends ArtistState {}

class ArtistsLoaded extends ArtistState {
  final List<String> artists;

  ArtistsLoaded({required this.artists});

  @override
  List<Object> get props => [artists];
}

class ArtistSongsLoaded extends ArtistState {
  final String artist;
  final List<Song> songs;

  ArtistSongsLoaded({required this.artist, required this.songs});

  @override
  List<Object> get props => [artist, songs];
}