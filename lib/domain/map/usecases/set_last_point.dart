import 'package:trezvii_24_driver/domain/map/repository/repository.dart';

import '../models/app_lat_long.dart';

class SetLastPoint {
  final MapRepository repository;

  SetLastPoint(this.repository);

  Future call (AppLatLong point) {
    return repository.setLastPoint(point);
  }
}