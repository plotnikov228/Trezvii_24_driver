import 'package:trezvii_24_driver/domain/payment/models/output_request.dart';
import 'package:trezvii_24_driver/domain/payment/repository/repostitory.dart';

class CreateALocalOutputRequest {
  final PaymentRepository repository;

  CreateALocalOutputRequest(this.repository);

  Future call(LocalOutputRequest localOutputRequest) {
    return repository.createALocalOutputRequest(localOutputRequest: localOutputRequest);
  }
}
