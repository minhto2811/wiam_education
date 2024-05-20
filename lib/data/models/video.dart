class Video {
  String _id;
  String _title;
  String _image;
  String _video;
  String _description;

  Video(this._id, this._title, this._image, this._video, this._description);

  String get id => _id;

  String get title => _title;

  String get image => _image;

  String get video => _video;

  String get description => _description;

  factory Video.fromJson(Map<String, dynamic> map) {
    return Video(map['id'], map['title'], map['image'], map['video'],
        map['description']);
  }
}
