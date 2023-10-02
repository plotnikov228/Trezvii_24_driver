
import 'package:trezvii_24_driver/domain/firebase/notification/repository.dart';

class UserSubscribeToNewsletter {
  final NotificationRepository repository;

  UserSubscribeToNewsletter(this.repository);

  Future<bool> call () => repository.userSubscribeToNewsletter();
}