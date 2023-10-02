import 'package:trezvii_24_driver/domain/firebase/order/repository/repository.dart';

import '../model/order.dart';

class UpdateOrderById {
  final OrderRepository repository;

  UpdateOrderById(this.repository);

  Future<Order?> call (String id, Order order) {
    return repository.updateOrderById(id, order);
  }
}