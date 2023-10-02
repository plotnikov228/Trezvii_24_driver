import 'package:trezvii_24_driver/domain/map/models/address_model.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../payment/models/tariff.dart';
import '../models/app_lat_long.dart';

abstract class MapRepository {
  Future<AppLatLong> getCurrentLocation();

  Future<bool> requestPermission();

  Future<bool> checkPermission();

  Future<AppLatLong> getLastPoint();

  Stream<AppLatLong> positionStream ();

  Future<AddressModel?> getAddressFromPoint (AppLatLong point);

  Future<List<AddressModel>> getAddressesFromText (String address, AppLatLong point);

  Future setLastPoint(AppLatLong point);

  Future<List<DrivingRoute>?> getRoutes (List<AppLatLong> points);

  Future<Duration> getDurationBetweenTwoPoints(AppLatLong first, AppLatLong second);

  Future<double> getCostInRub(Tariff tariff,DrivingRoute route);

  Future<String?> getLocally ();

  Future<String> setLocally (String locally);


}