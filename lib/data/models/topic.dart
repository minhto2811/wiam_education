class Topic {
  String _id;
  String _title;
  String _image;
  int _countLesson;

  Topic(this._id, this._title, this._image, this._countLesson);

  String get id => _id;

  String get title => _title;

  String get image => _image;

  int get countLesson => _countLesson;


  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(json['id'], json['title'], json['image'], json['countLesson'] as int);
  }
}
