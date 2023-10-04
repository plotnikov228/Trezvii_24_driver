import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trezvii_24_driver/data/auth/repository/repository.dart';
import 'package:trezvii_24_driver/data/firebase/order/repository.dart';
import 'package:trezvii_24_driver/domain/auth/usecases/get_user_id.dart';
import 'package:trezvii_24_driver/domain/firebase/balance/models/balance_model.dart';
import 'package:trezvii_24_driver/domain/firebase/order/usecases/get_order_by_id.dart';
import 'package:trezvii_24_driver/domain/firebase/order/usecases/update_order_by_id.dart';
import 'package:trezvii_24_driver/domain/payment/models/output_request.dart';

import '../../../domain/firebase/balance/repository.dart';

class FirebaseBalanceRepositoryImpl extends FirebaseBalanceRepository {
  final _balancesCollection = 'Balances';
  final _balanceCollection = 'Balance';
  final _withdrawalRequestsCollections = 'WithdrawalRequests';
  final _instance = FirebaseFirestore.instance;

  final _orderRepo = OrderRepositoryImpl();

  @override
  Future addSumToBalance(
      {required LocalOutputRequest localOutputRequest,
      required String id}) async {
    final doc = _instance
        .collection(_balancesCollection)
        .doc(id)
        .collection(_balanceCollection)
        .doc(localOutputRequest.orderId);
    if (!(await doc.get()).exists) {
      final order =
          await GetOrderById(_orderRepo).call(localOutputRequest.orderId);
      if (!(order?.isPaid ?? true)) {
        final balance = BalanceModel(cost: order!.costInRub);
        await doc.set(balance.toJson());
      }
    }
  }

  @override
  Future<double> getBalance({required String id}) async {
    final docs = await _instance
        .collection(_balanceCollection)
        .doc(id)
        .collection(_balancesCollection)
        .get();
    final balances =
        docs.docs.map((e) => BalanceModel.fromJson(e.data())).toList();
    double balance = 0;
    balances.map((e) => balance += e.cost);
    return balance;
  }

  @override
  Future resetTheBalance({required String id}) async {
    final docs = await _instance
        .collection(_balanceCollection)
        .doc(id)
        .collection(_balancesCollection)
        .get();
    for (var item in docs.docs) {
      GetOrderById(_orderRepo).call(item.id).then((value) async {
        if (value != null) {
          UpdateOrderById(_orderRepo).call(item.id, value);
        }
        await _instance
            .collection(_balanceCollection)
            .doc(id)
            .collection(_balancesCollection)
            .doc(item.id)
            .delete();
      });
    }
  }

  @override
  Future createWithdrawalRequest() async {
    final id = await GetUserId(AuthRepositoryImpl()).call();
    final balance = await getBalance(id: id);
    if (balance > 0) {
      await _instance
          .collection(_balanceCollection)
          .doc(id)
          .set({'cost': balance});
    }
  }
}
