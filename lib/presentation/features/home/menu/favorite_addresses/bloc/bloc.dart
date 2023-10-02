import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trezvii_24_driver/data/db/repository/repository.dart';
import 'package:trezvii_24_driver/domain/db/usecases/db_insert.dart';
import 'package:trezvii_24_driver/domain/db/usecases/db_query.dart';
import 'package:trezvii_24_driver/domain/db/usecases/init_db.dart';
import 'package:trezvii_24_driver/domain/map/models/address_model.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/favorite_addresses/bloc/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/favorite_addresses/bloc/state.dart';
import 'package:trezvii_24_driver/presentation/routes/routes.dart';

import '../../../../../../domain/db/constants.dart';

class FavoriteAddressesBloc extends Bloc<FavoriteAddressesEvent, FavoriteAddressesState>{

  late final List<AddressModel> _addresses;
  final _dbRepo = DBRepositoryImpl();
  FavoriteAddressesBloc(super.initialState) {

    on<InitFavoriteAddressesEvent>((event, emit) async {
      _addresses = (await DBQuery(_dbRepo).call(DBConstants.favoriteAddressesTable)).map((e) => AddressModel.fromDB(e)).toList();
      emit(FavoriteAddressesState(_addresses));
    });

    on<GoToNewPageForAddNewAddressEvent>((event, emit) async {
      event.context.pushNamed<AddressModel?>(AppRoutes.addNewAddress).then((value) {
        if(value != null) {
          add(AddAddressEvent(value));
        }
      });
    });

    on<AddAddressEvent>((event, emit) async {
      print('new Address');
      await InitDB(_dbRepo).call();
      await DBInsert(_dbRepo).call(DBConstants.favoriteAddressesTable, event.addressModel.toDBFormat());
      _addresses.add(event.addressModel);
      emit(FavoriteAddressesState(_addresses));
    });
  }

}