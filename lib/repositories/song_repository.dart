import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/song_model.dart';

class SongRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Song>> fetchSongs() async {
    final snapshot = await _firestore.collection('songs').get();
    return snapshot.docs
        .map((doc) => Song.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
