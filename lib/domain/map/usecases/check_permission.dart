import 'package:trezvii_24_driver/domain/map/repository/repository.dart';

class CheckPermission {
  final MapRepository repository;

  CheckPermission(this.repository);

  Future<bool> call () {
    return repository.checkPermission();
  }
}