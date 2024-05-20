

import 'package:wiam/data/models/question.dart';
import 'package:wiam/data/repositories/question_repository.dart';

class GetQuestionByIdUseCase {
  final QuestionRepository _questionRepository;

  GetQuestionByIdUseCase(this._questionRepository);

  Future<Question?> call(String id) async {
    return await _questionRepository.getQuestionByTypeId(id);
  }
}