// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encrypted_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_EncryptedMessage _$$_EncryptedMessageFromJson(Map<String, dynamic> json) =>
    _$_EncryptedMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      rsaEncryptedMessage: json['rsaEncryptedMessage'] as String,
      aesEncryptedMessage: json['aesEncryptedMessage'] as String,
    );

Map<String, dynamic> _$$_EncryptedMessageToJson(_$_EncryptedMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'rsaEncryptedMessage': instance.rsaEncryptedMessage,
      'aesEncryptedMessage': instance.aesEncryptedMessage,
    };
