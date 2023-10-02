import 'package:trezvii_24_driver/domain/firebase/chat/models/chat.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/repository.dart';

class DeleteChatById {
  final ChatRepository repository;

  DeleteChatById(this.repository);

  Future call ({required String id}) {
    return repository.deleteChatById(id);
  }
}