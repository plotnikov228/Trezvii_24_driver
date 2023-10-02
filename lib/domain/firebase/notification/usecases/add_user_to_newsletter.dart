
import 'package:trezvii_24_driver/domain/firebase/notification/repository.dart';

class AddUserToNewsletter {
  final NotificationRepository repository;

  AddUserToNewsletter(this.repository);

  Future call () => repository.addUserToNewsletter();
}