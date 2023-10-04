import 'package:trezvii_24_driver/data/auth/repository/repository.dart';
import 'package:trezvii_24_driver/data/firebase/balance/repository.dart';
import 'package:trezvii_24_driver/data/payment/repository/repository.dart';
import 'package:trezvii_24_driver/domain/auth/usecases/get_user_id.dart';
import 'package:trezvii_24_driver/domain/firebase/balance/usecases/get_balance.dart';
import 'package:trezvii_24_driver/domain/firebase/balance/usecases/reset_the_balance.dart';
import 'package:trezvii_24_driver/domain/payment/usecases/complete_output_request.dart';
import 'package:trezvii_24_driver/domain/payment/usecases/create_a_local_output_request.dart';
import 'package:trezvii_24_driver/domain/payment/usecases/get_requests.dart';

import '../../../../../../domain/payment/models/output_request.dart';
import '../../../../../../domain/payment/usecases/cancel_output_request.dart';

class BalanceFunctions {
  late final List<LocalOutputRequest> _requests;
  List<LocalOutputRequest> get requests => _requests;

  final _paymentRepo = PaymentRepositoryImpl();
  final _fbBalanceRepo = FirebaseBalanceRepositoryImpl();
  final _authRepo = AuthRepositoryImpl();

  Future init () async {
    _requests = await GetRequests(_paymentRepo).call();
    for(var item in _requests) {
      completeRequest(item);
    }
  }

  Future completeRequest (LocalOutputRequest localOutputRequest) async {
    await CompleteOutputRequest(_paymentRepo).call(localOutputRequest);
    _requests.remove(localOutputRequest);
  }

  Future createRequest (LocalOutputRequest localOutputRequest) async {
    await CreateALocalOutputRequest(_paymentRepo).call(localOutputRequest);
    _requests.add(localOutputRequest);
  }

  Future cancelRequest(LocalOutputRequest localOutputRequest) async {
  await CancelOutputRequest(_paymentRepo).call(localOutputRequest);
  _requests.add(localOutputRequest);
}

}