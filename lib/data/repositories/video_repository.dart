import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wiam/data/models/video.dart';

abstract interface class VideoRepository {
  Future<List<Video>> getListVideo(String language);
}

class VideoRepositoryImpl implements VideoRepository {
  final FirebaseFirestore _firestore;

  VideoRepositoryImpl(this._firestore);

  @override
  Future<List<Video>> getListVideo(String language) async {
    final snapshot = await _firestore
        .collection('videos')
        .where('language', isEqualTo: language)
        .get();
    return List.from(snapshot.docs.map((doc) => Video.fromJson(doc.data())));
  }
}
