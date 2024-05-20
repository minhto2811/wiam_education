class Test {
  final String _id;
  final String _title;

  Test(this._id, this._title);

  String get id => _id;

  String get title => _title;

  factory Test.fromJson(Map<String, dynamic> json) =>
      Test(json['id'], json['title']);
}
