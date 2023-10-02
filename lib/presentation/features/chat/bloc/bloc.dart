import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trezvii_24_driver/data/auth/repository/repository.dart';
import 'package:trezvii_24_driver/data/firebase/auth/models/driver.dart';
import 'package:trezvii_24_driver/data/firebase/auth/repository.dart';
import 'package:trezvii_24_driver/domain/auth/usecases/get_user_id.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/repository/repository.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/usecases/get_driver_by_id.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/usecases/get_user_by_id.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/models/chat_messages.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/usecases/find_chat_by_id.dart';
import 'package:trezvii_24_driver/domain/firebase/chat/usecases/send_message_to_chat.dart';
import 'package:trezvii_24_driver/presentation/features/chat/bloc/event.dart';
import 'package:trezvii_24_driver/presentation/features/chat/bloc/state.dart';

import '../../../../data/firebase/chat/repository.dart';
import '../../../../domain/firebase/auth/models/user_model.dart';
import '../../../../domain/firebase/chat/models/chat.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Chat? _chat;
  late final String yourId;
  String? talkerPhotoUrl;
  late UserModel? talker;
  final _repo = ChatRepositoryImpl();

  final String chatId;

  ChatBloc(super.initialState, this.chatId) {

    on<LoadChatEvent>((event, emit) async {

      yourId = await GetUserId(AuthRepositoryImpl()).call();
      final chat = await FindChatById(_repo).call(id: event.chatId);
      if (chat == null) {
        emit(ChatState(status: ChatStateStatus.chatDoesNotExist));
      } else {
          talker = (await GetUserById(FirebaseAuthRepositoryImpl()).call(chat!.employerId));
          try {
            talkerPhotoUrl =
            await FirebaseStorage.instance.ref('${talker?.userId}/photo')
                .getDownloadURL();
          } catch (_) {

          }

        _chat = chat;
        emit(ChatState(
          scrollController: _scrollController,
            status: ChatStateStatus.success,
            chat: _chat!,
            controller: _controller));
      }
    });

    on<SendMessageChatEvent>((event, emit) async {
      if (_controller.text.trim().isNotEmpty) {
        await SendMessageToChat(_repo).call(
            message: ChatMessages(
                idFrom: _chat!.driverId,
                idTo: _chat!.employerId,
                timestamp: DateTime.now().toIso8601String(),
                content: _controller.text.trim()),
            chatId: chatId);
        _controller.text = '';
      }
    });
  }
}
