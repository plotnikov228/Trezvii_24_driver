import 'package:trezvii_24_driver/domain/firebase/order/model/order.dart';
import 'package:trezvii_24_driver/domain/firebase/order/repository/repository.dart';

class SetChangesOrderListener {
  final OrderRepository repository;

  SetChangesOrderListener(this.repository);

  Stream<Order?> call(String orderId) {
    return repository.setOrderChangesListener( orderId);
  }
}