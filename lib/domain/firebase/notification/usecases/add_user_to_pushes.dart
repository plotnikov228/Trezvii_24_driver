
import 'package:trezvii_24_driver/domain/firebase/notification/repository.dart';

class AddUserToPushes {
  final NotificationRepository repository;

  AddUserToPushes(this.repository);

  Future call () => repository.addUserToPushes();
}