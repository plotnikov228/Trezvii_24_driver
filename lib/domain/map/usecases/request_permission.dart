import 'package:trezvii_24_driver/domain/map/repository/repository.dart';

class RequestPermission {
  final MapRepository repository;

  RequestPermission(this.repository);

  Future<bool> call () {
    return repository.requestPermission();
  }
}