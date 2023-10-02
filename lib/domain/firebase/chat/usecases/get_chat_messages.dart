import 'package:trezvii_24_driver/domain/firebase/chat/models/chat.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/models/chat_messages.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/repository.dart';

class GetChatMessages {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  Stream<List<ChatMessages>> call ({required String chatId, required int limit}) {
    return repository.getChatMessage(chatId, limit);
  }
}