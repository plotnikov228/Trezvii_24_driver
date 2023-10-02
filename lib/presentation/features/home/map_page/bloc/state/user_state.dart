import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/state/state.dart';

import '../../../../../../domain/payment/models/payment_ui_model.dart';
import '../../../../../../domain/payment/models/tariff.dart';

class StartOrderUserMapState extends StartOrderMapState {
  final int currentIndexTariff;
  final List<Tariff>? tariffList;
  final PaymentUiModel? currentPaymentUiModel;
  final bool canCreateOrder;


  StartOrderUserMapState(
      {this.canCreateOrder = true, this.currentIndexTariff = 0, this.tariffList, this.currentPaymentUiModel, super.status, super.exception, super.message});

}