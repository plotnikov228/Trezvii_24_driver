import 'package:trezvii_24_driver/domain/firebase/auth/models/personal_data_of_the_driver.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/models/user_model.dart';

import '../../../../data/firebase/auth/models/driver.dart';
import '../../../../data/firebase/auth/models/user.dart';
import '../../../map/models/app_lat_long.dart';
import '../models/car.dart';

abstract class FirebaseAuthRepository {
  Future<UserModel?> createUser(User userModel);

  Future<UserModel?> getUserById(String userId);

  Future<bool> userIsExist(String number);

  Future addUserToExisted(UserModel userModel);

  Future updateUser( String id,
      {String? number, String? email, String? name, int? bonuses, List<double>? ratings});

  Future<UserModel?> sendDriverDataForVerification(Driver driverModel);

  Future<UserModel?> getDriverById(String userId);

  Future updateDriver(String id,{
    String? number,
    String? email,
    bool? blocked,
    String? name,
    AppLatLong? currentPosition,
    Car? car,
    PersonalDataOfTheDriver? personalDataOfTheDriver,
    List<double>? ratings,
  });
}
