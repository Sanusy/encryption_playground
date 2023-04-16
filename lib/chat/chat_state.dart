import 'package:encryption_playground/model/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required String enteredMessage,
    required bool isLoading,
    required List<Message> messages,
  }) = _ChatState;

  factory ChatState.initial() => const ChatState(
        enteredMessage: '',
        isLoading: false,
        messages: [],
      );
}
