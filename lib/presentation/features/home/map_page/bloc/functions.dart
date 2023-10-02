
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trezvii_24_driver/data/firebase/auth/repository.dart';
import 'package:trezvii_24_driver/data/map/repository/repository.dart';
import 'package:trezvii_24_driver/domain/map/usecases/position_stream.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/functions/addresses_functions.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/functions/driver_position_functions.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/functions/map_functions.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/functions/order_changes_functions.dart';

import '../../../../../domain/firebase/auth/usecases/update_driver.dart';
import 'bloc/bloc.dart';
import 'functions/balance_functions.dart';
import 'functions/payments_functions.dart';

class MapBlocFunctions {
  final MapBloc bloc;
  MapBlocFunctions(this.bloc) {
    driverPositionFunctions = DriverPositionFunctions(bloc);
    orderFunctions = OrderChangesFunctions(bloc, this);
    paymentsFunctions = PaymentsFunctions();
    addressesFunctions = AddressesFunctions(bloc);
    mapFunctions = MapFunctions(bloc);
    balanceFunctions = BalanceFunctions();
  }

  late final DriverPositionFunctions driverPositionFunctions;
  late final OrderChangesFunctions orderFunctions;
  late final PaymentsFunctions paymentsFunctions;
  late final AddressesFunctions addressesFunctions;
  late final MapFunctions mapFunctions;
  late final BalanceFunctions balanceFunctions;

  Future userInit () async {
    await addressesFunctions.init();
    await addressesFunctions.initLocalities();
    print(' localities - ${addressesFunctions.localities}');
    await paymentsFunctions.init();
    await orderFunctions.initForUser();
    }

    Future driverInit () async {
      await addressesFunctions.initLocalities();
      print(' localities - ${addressesFunctions.localities}');
      await orderFunctions.initForDriver();
      PositionStream(MapRepositoryImpl()).call().listen((event) {
        UpdateDriver(FirebaseAuthRepositoryImpl()).call(FirebaseAuth.instance.currentUser!.uid, currentPosition: event);
      });
    }
}


