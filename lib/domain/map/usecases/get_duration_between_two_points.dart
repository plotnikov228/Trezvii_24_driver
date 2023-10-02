import 'package:trezvii_24_driver/domain/map/models/app_lat_long.dart';
import 'package:trezvii_24_driver/domain/map/repository/repository.dart';
import 'package:trezvii_24_driver/presentation/app.dart';

class GetDurationBetweenTwoPoints {
  final MapRepository repository;

  GetDurationBetweenTwoPoints(this.repository);

  Future<Duration> call (AppLatLong first, AppLatLong second) {
    return repository.getDurationBetweenTwoPoints(first, second);
  }
}