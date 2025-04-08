import 'package:equatable/equatable.dart';

abstract class ArtistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadArtists extends ArtistEvent {}

class SelectArtist extends ArtistEvent {
  final String artist;

  SelectArtist({required this.artist});

  @override
  List<Object> get props => [artist];
}