import 'package:trezvii_24_driver/domain/firebase/order/repository/repository.dart';
import 'package:trezvii_24_driver/presentation/utils/status_enum.dart';

import '../model/order.dart';

class DeleteOrderById {
  final OrderRepository repository;

  DeleteOrderById(this.repository);

  Future<Status> call (String id) {
    return repository.deleteOrderById(id);
  }
}