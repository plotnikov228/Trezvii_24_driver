import 'package:trezvii_24_driver/domain/firebase/chat/models/chat.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/repository.dart';

class CreateChat {
  final ChatRepository repository;

  CreateChat(this.repository);

  Future<Chat> call ({required String driverId, required String employerId}) {
    return repository.createChat(driverId, employerId);
  }
}