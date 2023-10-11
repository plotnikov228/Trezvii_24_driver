import 'package:trezvii_24_driver/domain/payment/models/output_request.dart';

import '../../payment/models/card.dart';

abstract class FirebaseBalanceRepository {
  Future<double> getBalance({required String id});

  Future addSumToBalance ({required LocalOutputRequest localOutputRequest,required String id});

  Future resetTheBalance ({required String id});

  Future createWithdrawalRequest (UserCard card);
}