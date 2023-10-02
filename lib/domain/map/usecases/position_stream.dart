import 'package:trezvii_24_driver/domain/map/repository/repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../models/app_lat_long.dart';

class PositionStream {
  final MapRepository repository;

  PositionStream(this.repository);

  Stream<AppLatLong> call () {
    return repository.positionStream();
  }
}