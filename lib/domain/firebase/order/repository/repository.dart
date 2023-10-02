import 'package:trezvii_24_driver/domain/firebase/order/model/order.dart';

import '../../../../presentation/utils/status_enum.dart';
import '../model/order_with_id.dart';

abstract class OrderRepository {
  Future<Order?> getOrderById (String id);

  Future<String> createOrder (Order order);

  Stream<List<OrderWithId>> getListOfOrders (String locality);

  Future<Status> deleteOrderById (String id);

  Future<List<OrderWithId>> getYourOrders ();

  Future<Order?> updateOrderById (String id, Order order);

  Stream<Order?> setOrderChangesListener(String orderId);



}