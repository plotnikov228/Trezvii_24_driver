import 'package:trezvii_24_driver/domain/tutorial/models/tariff_model.dart';

abstract class TutorialRepository {

  Future<List<TariffModel>> getListTariff();
}