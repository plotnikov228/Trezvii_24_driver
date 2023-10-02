import 'package:trezvii_24_driver/domain/firebase/auth/repository/repository.dart';

import '../models/user_model.dart';

class AddUserToExisted {
  final FirebaseAuthRepository repository;

  AddUserToExisted(this.repository);

  Future call(UserModel userModel) async {
    return repository.addUserToExisted(userModel);
  }
}