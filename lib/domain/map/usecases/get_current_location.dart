import 'package:trezvii_24_driver/domain/map/models/app_lat_long.dart';
import 'package:trezvii_24_driver/domain/map/repository/repository.dart';

class GetCurrentLocation {
  final MapRepository repository;

  GetCurrentLocation(this.repository);

  Future<AppLatLong> call () {
    return repository.getCurrentLocation();
  }
}