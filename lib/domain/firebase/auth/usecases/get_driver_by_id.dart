import 'package:trezvii_24_driver/domain/firebase/auth/repository/repository.dart';

import '../models/user_model.dart';

class GetDriverById {
  final FirebaseAuthRepository repository;

  GetDriverById(this.repository);

  Future<UserModel?> call(String id) async {
    return repository.getDriverById(id);
  }
}
