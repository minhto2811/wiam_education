class Lesson {
  String _id;
  String _title;
  String _audio;
  String _audio2;
  String _image;

  Lesson(this._id, this._title, this._audio, this._audio2, this._image);

  factory Lesson.fromJson(Map<String, dynamic> map) {
    return Lesson(
        map['id'], map['title'], map['audio'], map['audio2'], map['image']);
  }

  String get id => _id;

  String get title => _title;

  String get image => _image;

  String get audio => _audio;

  String get audio2 => _audio2;
}
