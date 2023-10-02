import 'package:flutter/cupertino.dart';
import 'package:trezvii_24_driver/domain/map/models/address_model.dart';

abstract class FavoriteAddressesEvent {}

class GoToNewPageForAddNewAddressEvent extends FavoriteAddressesEvent {
  final BuildContext context;

  GoToNewPageForAddNewAddressEvent(this.context);
}

class AddAddressEvent extends FavoriteAddressesEvent {
  final AddressModel addressModel;

  AddAddressEvent(this.addressModel);
}

class InitFavoriteAddressesEvent extends FavoriteAddressesEvent {
}