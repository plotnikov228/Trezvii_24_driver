import 'package:trezvii_24_driver/domain/payment/models/output_request.dart';
import 'package:trezvii_24_driver/domain/payment/repository/repostitory.dart';

class GetRequests {
  final PaymentRepository repository;

  GetRequests(this.repository);

  Future<List<LocalOutputRequest>> call() {
    return repository.getRequests();
  }
}
