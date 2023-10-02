import 'package:trezvii_24_driver/domain/firebase/chat/models/chat.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/models/chat_messages.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/repository.dart';

class FindChat {
  final ChatRepository repository;

  FindChat(this.repository);

  Future<Chat?> call ({required String driverId, required String employerId}) {
    return repository.findChat(driverId, employerId);
  }
}