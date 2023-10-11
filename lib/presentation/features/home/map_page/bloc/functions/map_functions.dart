import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trezvii_24_driver/data/firebase/auth/repository.dart';
import 'package:trezvii_24_driver/data/map/repository/repository.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/usecases/update_driver.dart';
import 'package:trezvii_24_driver/domain/firebase/order/model/order_status.dart';
import 'package:trezvii_24_driver/domain/map/usecases/get_address_from_point.dart';
import 'package:trezvii_24_driver/domain/map/usecases/get_routes.dart';
import 'package:trezvii_24_driver/domain/map/usecases/position_stream.dart';
import 'package:trezvii_24_driver/presentation/app.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../../../domain/map/models/address_model.dart';
import '../../../../../../domain/map/models/app_lat_long.dart';
import '../bloc/bloc.dart';
import '../event/event.dart';

class MapFunctions {
  final MapBloc bloc;
  MapFunctions(this.bloc);



  StreamSubscription<AppLatLong>? _currentPosition;
  StreamController<DrivingRoute>? _routeStream;
  Stream<DrivingRoute>? get positionStream => _routeStream?.stream;
  DrivingRoute? lastRoute ;
  final _repo = MapRepositoryImpl();
  final _fbRepo = FirebaseAuthRepositoryImpl();
  void initPositionStream ({bool driverMode = false, AppLatLong? to, Function()? whenComplete}) {
    _routeStream = StreamController.broadcast();
    _currentPosition = PositionStream(_repo).call().listen((event) async {
     print('changed position');
     print('to - $to');
     if(to != null) {
        final routes = await GetRoutes(_repo)
            .call([event, to]);
        if((routes?.isEmpty ?? true)) {
          final distance = Geolocator.distanceBetween(event.lat, event.long, to.lat, to.long);
          if((distance) <= 50 && whenComplete != null) whenComplete();

        }
        try {
          print('route');
          lastRoute = routes!.first;
          _routeStream!.add(routes.first);
        } catch(_) {

      }
        if((routes!.first.metadata.weight.distance.value ?? 50) <= 50 && whenComplete != null) whenComplete();
      }
   });
  }

  void disposePositionStream () {
    if(_currentPosition != null) _currentPosition!.cancel();
    _currentPosition = null;
    _routeStream?.close();
    _routeStream = null;
  }

  Future<AddressModel?> getCurrentAddress () async {
    Position? pos;
    try {
       pos = await Geolocator.getLastKnownPosition();
    } catch (_) {
      pos = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true, desiredAccuracy: LocationAccuracy.low);
    }
      if(pos != null) {
        return await GetAddressFromPoint(_repo).call(AppLatLong(lat: pos.latitude, long: pos.longitude));
      }
  }

  Future<AppLatLong?> getCurrentPosition () async {
    final pos = await Geolocator.getLastKnownPosition();
    if(pos != null) {
      return AppLatLong(lat: pos.latitude, long: pos.longitude);
    }
  }

}