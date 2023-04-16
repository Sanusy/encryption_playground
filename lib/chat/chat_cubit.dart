import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:encryption_playground/chat/chat_state.dart';
import 'package:encryption_playground/main.dart';
import 'package:encryption_playground/model/chat.dart';
import 'package:encryption_playground/model/message.dart';
import 'package:encryption_playground/model/user.dart';
import 'package:pointycastle/asymmetric/api.dart';

class ChatCubit extends Cubit<ChatState> {
  final Chat chat;
  final User userToChatWith;

  StreamSubscription? _messagesStreamSubscription;

  ChatCubit(this.chat, this.userToChatWith) : super(ChatState.initial());

  void onMessageChanged(String newMessage) {
    emit(state.copyWith(enteredMessage: newMessage));
  }

  Future<void> onSendMessage() async {
    final rsaEncryptedMessage = encryptionService.encryptRsa(
      RSAPublicKey(
        BigInt.parse(userToChatWith.publicKeyModulus),
        BigInt.parse(userToChatWith.publicKeyExponent),
      ),
      state.enteredMessage,
    );

    final aesEncryptedMessage =
        await encryptionService.aesEncrypt(state.enteredMessage);

    await firebaseService.sendMessage(
      chat,
      rsaEncryptedMessage,
      aesEncryptedMessage,
    );

    emit(state.copyWith(enteredMessage: ''));
  }

  Future<void> watchMessages() async {
    _messagesStreamSubscription?.cancel();
    firebaseService.watchMessages(chat).listen((encryptedMessage) async {
      final currentUserId = firebaseService.currentUserId!;

      final decryptedMessage = encryptedMessage.senderId == currentUserId
          ? await encryptionService
              .aesDecrypt(encryptedMessage.aesEncryptedMessage)
          : await encryptionService
              .decryptRsa(encryptedMessage.rsaEncryptedMessage);

      emit(state.copyWith(messages: [
        Message(
            id: encryptedMessage.id,
            isUserSender: encryptedMessage.senderId == currentUserId,
            message: decryptedMessage),
        ...state.messages,
      ]));
    });
  }

  @override
  Future<void> close() async {
    super.close();
    _messagesStreamSubscription?.cancel();
  }
}
