import 'package:wiam/data/repositories/question_repository.dart';

import '../../data/models/question.dart';

class GetListQuestionByIdTestUseCase {
  final QuestionRepository _questionRepository;

  GetListQuestionByIdTestUseCase(this._questionRepository);

  Future<List<Question>> call(String testId) async {
    return await _questionRepository.getListQuestionByTypeId(testId);
  }
}
