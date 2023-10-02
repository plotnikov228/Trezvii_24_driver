import 'package:trezvii_24_driver/domain/firebase/auth/repository/repository.dart';

class UpdateUser {
  final FirebaseAuthRepository repository;

  UpdateUser(this.repository);

  Future call (
      String id,{String? number, String? email, String? name, int? bonuses, List<double>? ratings}) async => repository.updateUser(id,name: name,number: number,bonuses: bonuses,email: email, ratings: ratings);
}