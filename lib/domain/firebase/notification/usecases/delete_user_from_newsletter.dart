
import 'package:trezvii_24_driver/domain/firebase/notification/repository.dart';

class DeleteUserFromNewsletter {
  final NotificationRepository repository;

  DeleteUserFromNewsletter(this.repository);

  Future call () => repository.deleteUserFromNewsletter();
}