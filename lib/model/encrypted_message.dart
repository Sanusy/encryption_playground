import 'package:freezed_annotation/freezed_annotation.dart';

part 'encrypted_message.freezed.dart';

part 'encrypted_message.g.dart';

@freezed
class EncryptedMessage with _$EncryptedMessage {
  const factory EncryptedMessage({
    required String id,
    required String senderId,
    required String rsaEncryptedMessage,
    required String aesEncryptedMessage,
  }) = _EncryptedMessage;

  factory EncryptedMessage.fromJson(Map<String, dynamic> json) => _$EncryptedMessageFromJson(json);
}
