class LessonToday {
  String _id;
  String _title;
  String _description;
  String _image;
  String _type;
  String _audio;

  LessonToday(this._id, this._title, this._description, this._image, this._type,
      this._audio);

  factory LessonToday.fromJson(Map<String, dynamic> json) {
    return LessonToday(json['id'], json['title'], json['description'],
        json['image'], json['type'], json['audio']);
  }

  String get id => _id;

  String get title => _title;

  String get description => _description;

  String get image => _image;

  String get type => _type;

  String get audio => _audio;

  static List<String> getList(Map<String, dynamic>? json) {
    if (json == null) return [];
    return json['ids'].cast<String>();
  }
}
