import 'package:trezvii_24_driver/domain/firebase/chat/models/chat.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/models/chat_messages.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/repository.dart';

class SendMessageToChat {
  final ChatRepository repository;

  SendMessageToChat(this.repository);

  Future call ({required ChatMessages message, required String chatId}) {
    return repository.sendMessageToChat(message, chatId);
  }
}