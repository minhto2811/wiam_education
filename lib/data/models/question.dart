class Question {
  String _id;
  String _question;
  List<String> _answers;
  String _correctAnswer;
  String _audio;

  Question(this._id, this._question, this._answers, this._correctAnswer,this._audio);

  String get id => _id;

  String get question => _question;

  List<String> get answers => _answers;

  String get correctAnswer => _correctAnswer;

  String get audio => _audio;

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        json['id'],
        json['question'],
        List<String>.from(json['answers']),
        json['correctAnswer'],
        json['audio']);
  }
}
