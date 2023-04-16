// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as String,
      userEmail: json['userEmail'] as String,
      publicKeyModulus: json['publicKeyModulus'] as String,
      publicKeyExponent: json['publicKeyExponent'] as String,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'userEmail': instance.userEmail,
      'publicKeyModulus': instance.publicKeyModulus,
      'publicKeyExponent': instance.publicKeyExponent,
    };
