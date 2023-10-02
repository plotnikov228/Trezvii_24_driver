import 'package:trezvii_24_driver/domain/firebase/auth/repository/repository.dart';

class UserIsExist {
  final FirebaseAuthRepository repository;

  UserIsExist(this.repository);

  Future<bool> call(String number) async {
    return repository.userIsExist(number);
  }
}