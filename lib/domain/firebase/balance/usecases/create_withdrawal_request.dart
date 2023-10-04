import 'package:trezvii_24_driver/domain/firebase/balance/repository.dart';

class CreateWithdrawalRequest {
  final FirebaseBalanceRepository repository;

  CreateWithdrawalRequest(this.repository);

  Future call () {
    return repository.createWithdrawalRequest();
  }
}