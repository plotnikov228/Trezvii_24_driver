import 'dart:async';

import 'package:trezvii_24_driver/data/firebase/auth/models/driver.dart';
import 'package:trezvii_24_driver/data/firebase/firestore/repository.dart';
import 'package:trezvii_24_driver/domain/firebase/firestore/usecases/track_status_change.dart';
import 'package:trezvii_24_driver/domain/map/models/app_lat_long.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/event/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/state/state.dart';


class DriverPositionFunctions {
  final MapBloc bloc;

  StreamSubscription<AppLatLong?>? _driverListener;

  DriverPositionFunctions(this.bloc);

  AppLatLong? get driverPosition => _driverPosition;
  AppLatLong? _driverPosition;



  setListenerOnDriverPosition(Driver driver, {Function? onUpdate}) {
    _driverListener = TrackStatusChange(FirebaseFirestoreRepositoryImpl())
        .call(collection: 'Drivers', docId: driver.userId)
        .map((event) =>
    event == null ? null : Driver.fromJson(event).currentPosition)
        .listen((event) {
      if (event != null) {
        _driverPosition = event;
      }
      if(onUpdate != null) {
        onUpdate();
      }
    });
  }

  disposeListenerOnDriverPosition() {
    if (_driverListener != null) {
      _driverPosition = null;
      _driverListener!.cancel();
      _driverListener = null;
    }
  }
}