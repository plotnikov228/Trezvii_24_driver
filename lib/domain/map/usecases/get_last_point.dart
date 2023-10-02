import 'package:trezvii_24_driver/domain/map/repository/repository.dart';

import '../models/app_lat_long.dart';

class GetLastPoint {
  final MapRepository repository;

  GetLastPoint(this.repository);

  Future<AppLatLong> call () {
    return repository.getLastPoint();
  }
}