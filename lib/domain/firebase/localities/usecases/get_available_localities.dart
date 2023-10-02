import 'package:trezvii_24_driver/domain/firebase/localities/repository.dart';
class GetAvailableLocalities {
  final LocalitiesRepository repo;

  GetAvailableLocalities(this.repo);

  Future<List<String>> call () => repo.getAvailableLocalities();
}