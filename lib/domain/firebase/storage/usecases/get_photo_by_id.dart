
import 'package:trezvii_24_driver/domain/firebase/storage/repository.dart';


class GetPhotoById {
  final FirebaseStorageRepository repository;

  GetPhotoById(this.repository);
  Future<String?> call (String id) {
    return repository.getPhotoById(id: id);
  }
}