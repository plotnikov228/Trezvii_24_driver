import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:trezvii_24_driver/data/auth/repository/repository.dart';
import 'package:trezvii_24_driver/data/firebase/auth/repository.dart';
import 'package:trezvii_24_driver/data/firebase/order/repository.dart';
import 'package:trezvii_24_driver/data/map/repository/repository.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/usecases/get_user_by_id.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/usecases/update_driver.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/usecases/update_user.dart';
import 'package:trezvii_24_driver/domain/firebase/order/usecases/get_list_of_orders.dart';
import 'package:trezvii_24_driver/domain/firebase/order/usecases/get_order_by_id.dart';
import 'package:trezvii_24_driver/domain/map/usecases/get_locally.dart';
import 'package:trezvii_24_driver/domain/map/usecases/set_locally.dart';
import 'package:trezvii_24_driver/domain/payment/enums/payment_types.dart';
import 'package:trezvii_24_driver/domain/payment/models/output_request.dart';
import 'package:trezvii_24_driver/domain/payment/models/payment_methods.dart';
import 'package:trezvii_24_driver/domain/payment/models/tariff.dart';
import 'package:trezvii_24_driver/extensions/double_extension.dart';
import 'package:trezvii_24_driver/extensions/duration_extension.dart';
import 'package:trezvii_24_driver/extensions/order_extension.dart';
import 'package:trezvii_24_driver/presentation/app.dart';
import 'package:trezvii_24_driver/presentation/features/home/map_page/bloc/bloc/bloc.dart';

import '../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../data/firebase/chat/repository.dart';
import '../../../../../../domain/auth/usecases/get_user_id.dart';
import '../../../../../../domain/firebase/auth/usecases/get_driver_by_id.dart';
import '../../../../../../domain/firebase/chat/usecases/delete_chat.dart';
import '../../../../../../domain/firebase/chat/usecases/find_chat.dart';
import '../../../../../../domain/firebase/order/model/order.dart';
import '../../../../../../domain/firebase/order/model/order_for_another.dart';
import '../../../../../../domain/firebase/order/model/order_status.dart';
import '../../../../../../domain/firebase/order/model/order_with_id.dart';
import '../../../../../../domain/firebase/order/usecases/create_order.dart';
import '../../../../../../domain/firebase/order/usecases/delete_order_by_id.dart';
import '../../../../../../domain/firebase/order/usecases/get_your_orders.dart';
import '../../../../../../domain/firebase/order/usecases/set_changes_order_listener.dart';
import '../../../../../../domain/firebase/order/usecases/update_order_by_id.dart';
import '../../../../../../domain/map/usecases/get_cost_in_rub.dart';
import '../../../../../../domain/map/usecases/get_routes.dart';
import '../../../../../utils/status_enum.dart';
import '../event/event.dart';
import '../functions.dart';
import '../state/state.dart';

class OrderChangesFunctions {
  final MapBloc bloc;
  final MapBlocFunctions mapBlocFunctions;

  OrderChangesFunctions(this.bloc, this.mapBlocFunctions);

  List<OrderWithId> activeOrders = [];
  List<OrderSubscription> listeners = [];

  String? _locality;

  String? get locality => _locality;

  bool _orderIsPreliminary = false;
  DateTime? _orderStartTime;

  DateTime get orderStartTime => _orderStartTime ?? DateTime.now();

  bool get orderIsPreliminary => _orderIsPreliminary;

  void setPreliminary(bool _) => _orderIsPreliminary = _;

  void setStartTime(DateTime? _) => _orderStartTime = _;

  final _orderRepo = OrderRepositoryImpl();
  final _mapRepo = MapRepositoryImpl();
  final _fbAuthRepo = FirebaseAuthRepositoryImpl();
  Order? currentOrder;
  String? currentOrderId;

  void setOrderListeners({String? id, Order? order}) {
    if (id != null && id == currentOrderId) {
      disposeOrderListener(id: id);
    }
    if (!(listeners.map((e) => e.orderId).contains(id))) {
      final listener = SetChangesOrderListener(_orderRepo)
          .call(id ?? currentOrderId!)
          .listen((event) async {
        if ((order ?? currentOrder!).status != event?.status && event != null) {
          if (order == null) {
            currentOrder = event;
          } else {
            order = event;
          }
          bloc.add(RecheckOrderMapEvent(id: id, order: order));
        }
        activeOrders = (await GetYourOrders(_orderRepo).call())
            .where((element) => element.order.isActive())
            .toList();
      });
      listeners.add(OrderSubscription(
          listener: listener, orderId: id ?? currentOrderId!));
    }
  }

  Future initForUser() async {
    activeOrders = (await GetYourOrders(_orderRepo).call())
        .where((element) => element.order.isActive())
        .toList();
    if (activeOrders.isNotEmpty) {
      final nearestOrder = activeOrders.nearestOrder();
      currentOrderId = nearestOrder.id;
      currentOrder = nearestOrder.order;
      bloc.fromAddress = currentOrder!.from;
      bloc.toAddress = currentOrder!.to;

      bloc.firstAddressController.text = bloc.fromAddress!.addressName;
      bloc.secondAddressController.text = bloc.toAddress!.addressName;

      bloc.currentRoute = (await GetRoutes(_mapRepo).call(
              [bloc.fromAddress!.appLatLong, bloc.toAddress!.appLatLong]))!
          .first;
      final dur = currentOrder!.startTime.difference(DateTime.now());
      if (dur.inDays > 0) {
        _orderIsPreliminary = true;
      }
      setOrderListeners();
      if (currentOrder?.driverId != null) {
        bloc.setDriver(await GetDriverById(FirebaseAuthRepositoryImpl())
            .call(activeOrders.first.order.driverId!) as Driver?);
      }
      bloc.setGetAddressFromMap(false);
      bloc.add(RecheckOrderMapEvent());
    }
  }

  Future initForDriver() async {
    activeOrders = (await GetYourOrders(_orderRepo).call())
        .where((element) => element.order.isActive())
        .toList();
    if (activeOrders.isNotEmpty) {
      final nearestOrder = activeOrders.nearestOrder();
      currentOrderId = nearestOrder.id;
      currentOrder = nearestOrder.order;
      bloc.fromAddress = currentOrder!.from;
      bloc.toAddress = currentOrder!.to;
      bloc.currentRoute = (await GetRoutes(_mapRepo).call(
              [bloc.fromAddress!.appLatLong, bloc.toAddress!.appLatLong]))!
          .first;
      bloc.add(RecheckOrderMapEvent());
    }
    _locality = await GetLocally(_mapRepo).call();
    print('locality -  $_locality');
    if (_locality == null) {
      final address = await mapBlocFunctions.mapFunctions.getCurrentAddress();
      if (address?.locality == null) {
        bloc.emit(bloc.state.copyWith(
            status: Status.Failed,
            exception: 'Не смогли определить ваш город'));
      } else {
        _locality = address!.locality;
        SetLocally(_mapRepo).call(_locality!);
      }
    }
  }

  Future cancelCurrentOrder(String? id, String reason) async {
    currentOrder = currentOrder!
        .copyWith(status: CancelledOrderStatus(), cancelReason: reason);
    final order =
        id != null ? (await GetOrderById(_orderRepo).call(id))! : currentOrder!;
    await UpdateOrderById(_orderRepo).call(
        id ?? currentOrderId!, order.copyWith(status: CancelledOrderStatus()));
    if (id == currentOrderId) {
      currentOrder = null;
      currentOrderId = null;
    }
    bloc.add(RecheckOrderMapEvent());
  }

  void disposeOrderListener({String? id}) {
    try {
      final _id = id ?? currentOrderId!;
      final subscription = listeners.where((element) {
        return element.orderId == _id;
      }).first;
      subscription.listener.cancel();
      listeners.removeWhere((element) => element.orderId == _id);
    } catch (_) {}
  }

  void goToAcceptedInFuture(Order order, Duration duration,
      {required Duration onRetry}) {
    Future.delayed(Duration(minutes: duration.inMinutes), () {
      if (activeOrders.isNotEmpty) {
        OrderWithId nearestOrder = activeOrders.nearestOrder();

        if (nearestOrder.order == order) {
          currentOrder = order;
          bloc.add(RecheckOrderMapEvent());
        } else if (onRetry.inMinutes > 2) {
          goToAcceptedInFuture(order, onRetry,
              onRetry: Duration(minutes: onRetry.inMinutes ~/ 2));
        }
      }
    });
  }

  Future recheckOrderStatus({String? id, Order? order}) async {
    if (currentOrder == null) {
      print('currentOrderId = null');
      if (activeOrders.isNotEmpty) {
        final nearest = activeOrders.nearestOrder();
        currentOrder = nearest.order;
        currentOrderId = nearest.id;
        if (listeners
            .where((element) => element.orderId == currentOrderId)
            .isNotEmpty) disposeOrderListener();
        if (listeners
            .where((element) => element.orderId == currentOrderId)
            .isEmpty) setOrderListeners();
      } else {
        if (listeners
            .where((element) => element.orderId == currentOrderId)
            .isNotEmpty) disposeOrderListener();
        currentOrderId = null;
        print('activeorders is empty');
        bloc.add(GoMapEvent(StartOrderMapState()));
      }
    }
    if (currentOrder != null) {
      print('currentOrder != null');
      switch (currentOrder!.status) {
        case WaitingForOrderAcceptanceOrderStatus():
          bloc.add(GoMapEvent(WaitingForOrderAcceptanceMapState()));
        case CancelledOrderStatus():
          bloc.add(GoMapEvent(CancelledOrderMapState()));
          mapBlocFunctions.mapFunctions.disposePositionStream();
          activeOrders.removeWhere((element) => element.id == currentOrderId!);
          currentOrder = null;
          currentOrderId = null;
          bloc.add(RecheckOrderMapEvent());
        case OrderCancelledByDriverOrderStatus():
          bloc.add(GoMapEvent(OrderCancelledByDriverMapState()));
        case OrderAcceptedOrderStatus():
          var diff = currentOrder!.startTime.difference(DateTime.now());
          if (diff.inHours >= 1) {
            goToAcceptedInFuture(
                currentOrder!, Duration(minutes: diff.inMinutes - 31),
                onRetry: const Duration(minutes: 15));
            bloc.add(GoMapEvent(StartOrderMapState(
                message:
                    'Водитель принял вашу заявку, за 30 минут до назначенного времени вы вернётесь в окно ожидания водителя')));
          } else {
            mapBlocFunctions.mapFunctions.initPositionStream(
                driverMode: true,
                to: bloc.fromAddress?.appLatLong,
                whenComplete: () async {
                  mapBlocFunctions.mapFunctions.disposePositionStream();
                  bloc.emit(bloc.state);
                  await UpdateOrderById(_orderRepo).call(currentOrderId!,
                      currentOrder!.copyWith(status: ActiveOrderStatus()));
                });

            bloc.setDriver(await GetDriverById(FirebaseAuthRepositoryImpl())
                .call(currentOrder!.driverId!) as Driver);
            bloc.add(GoMapEvent(OrderAcceptedMapState()));
          }
        case SuccessfullyCompletedOrderStatus():
          mapBlocFunctions.balanceFunctions
              .completeRequest(mapBlocFunctions.balanceFunctions.requests.last);
          bloc.add(GoMapEvent(OrderCompleteMapState()));
        case ActiveOrderStatus():
          mapBlocFunctions.mapFunctions.initPositionStream(
              driverMode: true,
              to: bloc.toAddress!.appLatLong,
              whenComplete: () async {
                print('when colmplete on active status');
                UpdateOrderById(_orderRepo).call(
                    currentOrderId!,
                    currentOrder!
                        .copyWith(status: SuccessfullyCompletedOrderStatus()));
                bloc.add(RecheckOrderMapEvent());
              });
          bloc.add(GoMapEvent(ActiveOrderMapState()));
      }
    }
  }

  Future createOrder(
    Tariff tariff, {
    required String wishes,
    required String otherName,
    required String otherNumber,
  }) async {
    final user = await GetUserById(_fbAuthRepo)
        .call(await GetUserId(AuthRepositoryImpl()).call());
    if (!(user?.blocked ?? true)) {
      final cost =
          await GetCostInRub(_mapRepo).call(tariff, bloc.currentRoute!);
      print(cost);
      final order = Order(WaitingForOrderAcceptanceOrderStatus(),
          from: bloc.fromAddress!,
          to: bloc.toAddress!,
          wishes: wishes.isNotEmpty ? wishes : null,
          distance: (bloc.currentRoute!.metadata.weight.distance.value! / 1000)
              .prettify(),
          employerId: await GetUserId(AuthRepositoryImpl()).call(),
          orderForAnother: otherName.isNotEmpty && otherNumber.isNotEmpty
              ? OrderForAnother(otherNumber, otherName)
              : null,
          startTime: orderStartTime,
          costInRub: cost,
          paymentMethod:
              bloc.currentPaymentModel.paymentType == PaymentTypes.card
                  ? CardPaymentMethod()
                  : CashPaymentMethod());

      await CreateOrder(_orderRepo).call(order).then((value) async {
        activeOrders.add(OrderWithId(order, value));
        if (currentOrder == null ||
            (activeOrders.nearestOrder().id != currentOrderId &&
                currentOrderId != null)) {
          if (activeOrders.nearestOrder().id != currentOrderId &&
              currentOrderId != null) {
            disposeOrderListener(id: currentOrderId);
            setOrderListeners(id: currentOrderId, order: currentOrder);
          }
          currentOrderId = value;
          currentOrder = order;
          setOrderListeners();
        }
        bloc.add(RecheckOrderMapEvent());
      });
    } else {
      bloc.emit(bloc.state.copyWith(
          message:
              'Вы не можете создавать заказы, так как более двух раз экстренно отменяли заказ. Что бы разблокировать аккаунт обратитесь в техническую поддержку'));
    }
  }

  Stream<List<OrderWithId>> availableOrders() =>
      GetListOfOrders(_orderRepo).call(_locality ?? '');

  Future cancelSearch({String? id}) async {
    final order =
        id == null ? currentOrder : await GetOrderById(_orderRepo).call(id);

    if (order != null && order.status is WaitingForOrderAcceptanceOrderStatus) {
      await DeleteOrderById(_orderRepo).call(id ?? currentOrderId!);
      activeOrders
          .removeWhere((element) => element.id == (id ?? currentOrderId));
      disposeOrderListener(id: id ?? currentOrderId);
      if ((id ?? currentOrderId) == currentOrderId) {
        currentOrder = null;
      }
      bloc.add(RecheckOrderMapEvent());
    }
  }

  Future completeOrder(
      {double? rating, required String uid, String? orderId}) async {
    if (rating != null) {
      final user = await GetUserById(_fbAuthRepo).call(uid);
      if (user != null) {
        user.ratings.add(rating);
        await UpdateUser(_fbAuthRepo).call(uid, ratings: user.ratings);
      }
    }
    if ((orderId ?? currentOrderId) == currentOrderId) {
      bloc.fromAddress = null;
      bloc.toAddress = null;
      bloc.currentRoute = null;
      currentOrder = null;
      currentOrderId = null;
      bloc.setDriver(null);
    }
    bloc.add(RecheckOrderMapEvent());
  }

  void proceedOrder() async {
    final driver = await GetDriverById(_fbAuthRepo)
        .call(await GetUserId(AuthRepositoryImpl()).call());
    if (!(driver?.blocked ?? true)) {
      GetOrderById(_orderRepo).call(currentOrderId!).then((val) {
        if (val != null) {
          if (val.status != WaitingForOrderAcceptanceOrderStatus() &&
              (val.driverId != null &&
                  val.driverId != FirebaseAuth.instance.currentUser!.uid)) {
            currentOrder = null;
            currentOrderId = null;
            bloc.emit(bloc.state.copyWith(
                exception: 'Заказ был взят другим водителем',
                status: Status.Failed));
          } else {
            mapBlocFunctions.balanceFunctions.createRequest(LocalOutputRequest(
                orderId: currentOrderId!,
                paymentMethod: currentOrder!.paymentMethod));
            UpdateOrderById(_orderRepo)
                .call(
                    currentOrderId!,
                    currentOrder!.copyWith(
                        driverId: FirebaseAuth.instance.currentUser!.uid,
                        status: OrderAcceptedOrderStatus()))
                .then((value) {
              setOrderListeners();
              bloc.add(RecheckOrderMapEvent());
            });
          }
        } else {
          currentOrder = null;
          currentOrderId = null;
          bloc.emit(bloc.state.copyWith(
              exception: 'Данный заказ был отменён пользователем',
              status: Status.Failed));
        }
      });
    } else {
      bloc.emit(bloc.state.copyWith(
          message:
              'Вы не можете принимать заказы, за дополнительной информацией обратитесь к диспетчеру'));
    }
  }
}

class OrderSubscription {
  final StreamSubscription<Order?> listener;
  final String orderId;

  OrderSubscription({required this.listener, required this.orderId});
}
