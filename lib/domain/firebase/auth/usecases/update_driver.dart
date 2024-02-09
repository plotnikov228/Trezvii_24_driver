import 'package:trezvii_24_driver/domain/firebase/auth/repository/repository.dart';

import '../../../map/models/app_lat_long.dart';
import '../models/car.dart';
import '../models/personal_data_of_the_driver.dart';

class UpdateDriver {
  final FirebaseAuthRepository repository;

  UpdateDriver(this.repository);

  Future call(String id,{
    String? number,
    String? email,
    String? name,
    AppLatLong? currentPosition,
    Car? car,
    bool? blocked,
    PersonalDataOfTheDriver? personalDataOfTheDriver,
    List<double>? ratings,
  }) async =>
      repository.updateDriver(id,
          number: number,
          name: name,
          email: email,
          currentPosition: currentPosition,
          car: car,
          blocked: blocked,
          personalDataOfTheDriver: personalDataOfTheDriver,
          ratings: ratings);
}
