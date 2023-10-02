import 'package:trezvii_24_driver/domain/map/models/address_model.dart';
import 'package:trezvii_24_driver/domain/map/models/app_lat_long.dart';
import 'package:trezvii_24_driver/domain/map/repository/repository.dart';

class GetAddressesFromText {
  final MapRepository repository;

  GetAddressesFromText(this.repository);

  Future<List<AddressModel>> call (String address, AppLatLong point) {
    return repository.getAddressesFromText(address, point);
  }
}