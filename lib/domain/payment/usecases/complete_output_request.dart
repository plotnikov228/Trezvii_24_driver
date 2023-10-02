import 'package:trezvii_24_driver/domain/payment/models/output_request.dart';
import 'package:trezvii_24_driver/domain/payment/repository/repostitory.dart';

class CompleteOutputRequest {
  final PaymentRepository repository;

  CompleteOutputRequest(this.repository);

  Future call(LocalOutputRequest localOutputRequest) {
    return repository.completeAOutputRequest(localOutputRequest: localOutputRequest);
  }
}
