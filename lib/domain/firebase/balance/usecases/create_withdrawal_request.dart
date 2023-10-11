import 'package:trezvii_24_driver/domain/firebase/balance/repository.dart';

import '../../../payment/models/card.dart';

class CreateWithdrawalRequest {
  final FirebaseBalanceRepository repository;

  CreateWithdrawalRequest(this.repository);

  Future call ({required UserCard card}) {
    return repository.createWithdrawalRequest(card);
  }
}