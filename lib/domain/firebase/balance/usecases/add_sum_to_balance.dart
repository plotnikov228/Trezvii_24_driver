import 'package:trezvii_24_driver/domain/firebase/balance/repository.dart';

import '../../../payment/models/output_request.dart';

class AddSumToBalance {
  final FirebaseBalanceRepository repository;

  AddSumToBalance(this.repository);

  Future call ({required LocalOutputRequest localOutputRequest, required String uid}) {
    return repository.addSumToBalance(localOutputRequest: localOutputRequest, id: uid);
  }
}