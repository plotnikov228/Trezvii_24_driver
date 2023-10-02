import 'package:trezvii_24_driver/domain/map/models/app_lat_long.dart';
import 'package:trezvii_24_driver/domain/map/repository/repository.dart';

import '../models/address_model.dart';


class GetAddressFromPoint {
  final MapRepository repository;

  GetAddressFromPoint(this.repository);

  Future<AddressModel?> call(AppLatLong point) {
    return repository.getAddressFromPoint(point);
  }
}