import 'package:trezvii_24_driver/domain/map/repository/repository.dart';

class SetLocally {
  final MapRepository repository;

  SetLocally(this.repository);

  Future<String> call (String locally) {
    return repository.setLocally(locally);
  }
}