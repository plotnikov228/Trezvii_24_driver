import 'package:trezvii_24_driver/domain/firebase/balance/repository.dart';

import '../../../payment/models/output_request.dart';

class ResetTheBalance {
  final FirebaseBalanceRepository repository;

  ResetTheBalance(this.repository);

  Future call ({required String uid}) {
    return repository.resetTheBalance(id: uid);
  }
}