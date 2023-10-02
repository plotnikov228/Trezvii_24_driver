import 'package:trezvii_24_driver/domain/firebase/order/repository/repository.dart';

import '../model/order.dart';

class GetOrderById {
  final OrderRepository repository;

  GetOrderById(this.repository);

  Future<Order?> call (String id) {
    return repository.getOrderById(id);
  }
}