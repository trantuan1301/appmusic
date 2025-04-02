class Song {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String songUrl;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.songUrl,
    this.isFavorite = false,
  });

  factory Song.fromFirestore(Map<String, dynamic> json, String id) {
    return Song(
      id: id,
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      songUrl: json['songUrl'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Song && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

