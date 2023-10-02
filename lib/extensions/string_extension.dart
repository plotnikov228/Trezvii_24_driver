import 'package:trezvii_24_driver/domain/firebase/order/model/order_status.dart';

extension StringExtension on String {
  OrderStatus getOrderStatusFromString() {
    switch (this) {
      case 'Active':
        return ActiveOrderStatus();
      case 'Cancelled':
        return CancelledOrderStatus();
      case 'Order accepted':
        return OrderAcceptedOrderStatus();
      case 'Emergency cancellation':
        return EmergencyCancellationOrderStatus();
      case 'Waiting for order acceptance':
        return WaitingForOrderAcceptanceOrderStatus();
      case 'Order cancelled by driver':
        return OrderCancelledByDriverOrderStatus();
      default:
        return SuccessfullyCompletedOrderStatus();
    }
  }
}
