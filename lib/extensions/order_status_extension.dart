import 'package:trezvii_24_driver/domain/firebase/order/model/order_status.dart';

extension OrderStatusExtension on OrderStatus {
  String description () {
    switch (this) {
      case EmergencyCancellationOrderStatus():
        return 'Был экстренно отменён';
      case ActiveOrderStatus():
        return 'Активный заказ';
      case WaitingForOrderAcceptanceOrderStatus():
        return 'Ожидайте водителя';
      case CancelledOrderStatus():
        return 'Заказ отменён';
      case SuccessfullyCompletedOrderStatus():
        return 'Поездка завершена';
      default:
        return 'Заказ принят';
    }
  }

  String descriptionForDriver () {
    switch (this) {
      case ActiveOrderStatus():
        return 'Активный заказ';
      case EmergencyCancellationOrderStatus():
        return 'Был экстренно отменён';
      case WaitingForOrderAcceptanceOrderStatus():
        return 'Ожидает водителя';
      case CancelledOrderStatus():
        return 'Заказ отменён';
      case SuccessfullyCompletedOrderStatus():
        return 'Поездка завершена';
      default:
        return 'Заказ принят';
    }
  }
}