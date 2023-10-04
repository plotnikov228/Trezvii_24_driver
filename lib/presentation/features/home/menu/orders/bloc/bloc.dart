import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trezvii_24_driver/data/firebase/auth/repository.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/usecases/get_driver_by_id.dart';
import 'package:trezvii_24_driver/domain/firebase/order/model/order_status.dart';
import 'package:trezvii_24_driver/presentation/app.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/orders/bloc/event.dart';
import 'package:trezvii_24_driver/presentation/features/home/menu/orders/bloc/state.dart';

import '../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../data/firebase/order/repository.dart';
import '../../../../../../domain/firebase/order/model/order_with_id.dart';
import '../../../../../../domain/firebase/order/usecases/get_your_orders.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final _orderRepo = OrderRepositoryImpl();
  final _firebaseAuthRepo = FirebaseAuthRepositoryImpl();
  late final List<OrderWithId> _otherOrders;
  late final List<OrderWithId> _completedOrders;
  OrdersBloc(super.initialState) {

    on<InitOrdersEvent>((event, emit) async {
      final allOrders = (await GetYourOrders(_orderRepo).call());

        _otherOrders = allOrders.where((element) =>
        element.order.status.toString() != OrderCancelledByDriverOrderStatus().toString() &&
            element.order.status.toString() != CancelledOrderStatus().toString() &&
            element.order.status.toString() != SuccessfullyCompletedOrderStatus().toString() && element.order.status.toString() != EmergencyCancellationOrderStatus().toString())
            .toList();

      _completedOrders = allOrders
          .where((element) =>
              element.order.status.toString() ==
              SuccessfullyCompletedOrderStatus().toString())
          .toList();
      emit(OrdersState(
          otherOrders: _otherOrders,
          completedOrders: _completedOrders,));
    });
  }
}
