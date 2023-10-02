import 'package:trezvii_24_driver/domain/tutorial/models/tariff_model.dart';
import 'package:trezvii_24_driver/domain/tutorial/repository/repository.dart';

class GetListTariff {
  final TutorialRepository repository;

  GetListTariff(this.repository);

  Future<List<TariffModel>> call () async {
    return repository.getListTariff();
  }
}