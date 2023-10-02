import 'dart:async';

import 'package:trezvii_24_driver/data/db/repository/repository.dart';
import 'package:trezvii_24_driver/data/firebase/localities/repository.dart';
import 'package:trezvii_24_driver/data/map/repository/repository.dart';
import 'package:trezvii_24_driver/domain/firebase/localities/usecases/get_available_localities.dart';
import 'package:trezvii_24_driver/domain/map/models/address_model.dart';
import 'package:trezvii_24_driver/domain/map/models/app_lat_long.dart';
import 'package:trezvii_24_driver/extensions/point_extension.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../../../domain/db/constants.dart';
import '../../../../../../domain/db/usecases/db_query.dart';
import '../../../../../../domain/map/usecases/get_addresses_from_text.dart';
import '../event/event.dart';
import '../state/state.dart';

class AddressesFunctions {
  final MapBloc bloc;

  AddressesFunctions(this.bloc);

  final _mapRepo = MapRepositoryImpl();
  final _dbRepo = DBRepositoryImpl();
  AddressModel? lastFavoriteAddress;

  late final List<String> _localities;
  List<String> get localities => _localities;


  Future initLocalities() async {
   _localities = await GetAvailableLocalities(LocalitiesRepositoryImpl()).call();
  }

  Future init() async {
    final favoriteAddresses = await getFavoriteAddresses();
    if (favoriteAddresses.isNotEmpty) {
      print('a');
      lastFavoriteAddress = favoriteAddresses.last;
      bloc.add(GoMapEvent(InitialMapState()));
    }
  }



  Future<List<AddressModel>> searchAddresses(
      String address, CameraPosition cameraPosition) async {
    late final List<AddressModel> result;
    if (address.isNotEmpty) {
      result = await GetAddressesFromText(_mapRepo)
          .call(address, cameraPosition!.target.toAppLatLong());
    } else {
      result = [];
    }
    return result;
  }

  Future<List<AddressModel>> getFavoriteAddresses() async {
    return (await DBQuery(_dbRepo).call(DBConstants.favoriteAddressesTable))
        .map((e) => AddressModel.fromDB(e))
        .toList();
  }


}
