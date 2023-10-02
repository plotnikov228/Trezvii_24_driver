
import 'package:trezvii_24_driver/domain/firebase/notification/repository.dart';

class DeleteUserFromPushes {
  final NotificationRepository repository;

  DeleteUserFromPushes(this.repository);

  Future call () => repository.deleteUserFromPushes();
}