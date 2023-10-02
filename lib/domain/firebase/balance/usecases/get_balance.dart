import 'package:trezvii_24_driver/domain/firebase/balance/repository.dart';

class GetBalance {
  final FirebaseBalanceRepository repository;

  GetBalance(this.repository);

  Future<double> call (String uid) {
    return repository.getBalance(id: uid);
  }
}