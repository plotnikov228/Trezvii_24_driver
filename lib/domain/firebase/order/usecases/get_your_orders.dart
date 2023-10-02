import 'package:trezvii_24_driver/domain/firebase/order/repository/repository.dart';

import '../model/order.dart';
import '../model/order_with_id.dart';

class GetYourOrders {
  final OrderRepository repository;

  GetYourOrders(this.repository);

  Future<List<OrderWithId>> call () {
    return repository.getYourOrders();
  }
}