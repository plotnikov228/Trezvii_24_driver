
import 'package:trezvii_24_driver/domain/firebase/notification/repository.dart';

class UserSubscribeToPushes {
  final NotificationRepository repository;

  UserSubscribeToPushes(this.repository);

  Future<bool> call () => repository.userSubscribeToPushes();
}