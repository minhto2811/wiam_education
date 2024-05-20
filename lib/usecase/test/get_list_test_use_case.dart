import 'package:wiam/data/repositories/test_repository.dart';

import '../../data/models/test.dart';

class GetListTestUseCase {
  final TestRepository _testRepository;

  GetListTestUseCase(this._testRepository);

  Future<List<Test>> call(String language) async {
    return await _testRepository.getListTest(language);
  }
}
