import 'package:trezvii_24_driver/domain/payment/models/output_request.dart';
import 'package:trezvii_24_driver/domain/payment/repository/repostitory.dart';

class CancelOutputRequest {
  final PaymentRepository repository;

  CancelOutputRequest(this.repository);

  Future call(LocalOutputRequest localOutputRequest) {
    return repository.cancelOutputRequest(localOutputRequest: localOutputRequest);
  }
}
