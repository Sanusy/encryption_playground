// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'encrypted_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

EncryptedMessage _$EncryptedMessageFromJson(Map<String, dynamic> json) {
  return _EncryptedMessage.fromJson(json);
}

/// @nodoc
mixin _$EncryptedMessage {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get rsaEncryptedMessage => throw _privateConstructorUsedError;
  String get aesEncryptedMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EncryptedMessageCopyWith<EncryptedMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EncryptedMessageCopyWith<$Res> {
  factory $EncryptedMessageCopyWith(
          EncryptedMessage value, $Res Function(EncryptedMessage) then) =
      _$EncryptedMessageCopyWithImpl<$Res, EncryptedMessage>;
  @useResult
  $Res call(
      {String id,
      String senderId,
      String rsaEncryptedMessage,
      String aesEncryptedMessage});
}

/// @nodoc
class _$EncryptedMessageCopyWithImpl<$Res, $Val extends EncryptedMessage>
    implements $EncryptedMessageCopyWith<$Res> {
  _$EncryptedMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? rsaEncryptedMessage = null,
    Object? aesEncryptedMessage = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      rsaEncryptedMessage: null == rsaEncryptedMessage
          ? _value.rsaEncryptedMessage
          : rsaEncryptedMessage // ignore: cast_nullable_to_non_nullable
              as String,
      aesEncryptedMessage: null == aesEncryptedMessage
          ? _value.aesEncryptedMessage
          : aesEncryptedMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EncryptedMessageCopyWith<$Res>
    implements $EncryptedMessageCopyWith<$Res> {
  factory _$$_EncryptedMessageCopyWith(
          _$_EncryptedMessage value, $Res Function(_$_EncryptedMessage) then) =
      __$$_EncryptedMessageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String senderId,
      String rsaEncryptedMessage,
      String aesEncryptedMessage});
}

/// @nodoc
class __$$_EncryptedMessageCopyWithImpl<$Res>
    extends _$EncryptedMessageCopyWithImpl<$Res, _$_EncryptedMessage>
    implements _$$_EncryptedMessageCopyWith<$Res> {
  __$$_EncryptedMessageCopyWithImpl(
      _$_EncryptedMessage _value, $Res Function(_$_EncryptedMessage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? rsaEncryptedMessage = null,
    Object? aesEncryptedMessage = null,
  }) {
    return _then(_$_EncryptedMessage(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      rsaEncryptedMessage: null == rsaEncryptedMessage
          ? _value.rsaEncryptedMessage
          : rsaEncryptedMessage // ignore: cast_nullable_to_non_nullable
              as String,
      aesEncryptedMessage: null == aesEncryptedMessage
          ? _value.aesEncryptedMessage
          : aesEncryptedMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_EncryptedMessage implements _EncryptedMessage {
  const _$_EncryptedMessage(
      {required this.id,
      required this.senderId,
      required this.rsaEncryptedMessage,
      required this.aesEncryptedMessage});

  factory _$_EncryptedMessage.fromJson(Map<String, dynamic> json) =>
      _$$_EncryptedMessageFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String rsaEncryptedMessage;
  @override
  final String aesEncryptedMessage;

  @override
  String toString() {
    return 'EncryptedMessage(id: $id, senderId: $senderId, rsaEncryptedMessage: $rsaEncryptedMessage, aesEncryptedMessage: $aesEncryptedMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EncryptedMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.rsaEncryptedMessage, rsaEncryptedMessage) ||
                other.rsaEncryptedMessage == rsaEncryptedMessage) &&
            (identical(other.aesEncryptedMessage, aesEncryptedMessage) ||
                other.aesEncryptedMessage == aesEncryptedMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, senderId, rsaEncryptedMessage, aesEncryptedMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EncryptedMessageCopyWith<_$_EncryptedMessage> get copyWith =>
      __$$_EncryptedMessageCopyWithImpl<_$_EncryptedMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EncryptedMessageToJson(
      this,
    );
  }
}

abstract class _EncryptedMessage implements EncryptedMessage {
  const factory _EncryptedMessage(
      {required final String id,
      required final String senderId,
      required final String rsaEncryptedMessage,
      required final String aesEncryptedMessage}) = _$_EncryptedMessage;

  factory _EncryptedMessage.fromJson(Map<String, dynamic> json) =
      _$_EncryptedMessage.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get rsaEncryptedMessage;
  @override
  String get aesEncryptedMessage;
  @override
  @JsonKey(ignore: true)
  _$$_EncryptedMessageCopyWith<_$_EncryptedMessage> get copyWith =>
      throw _privateConstructorUsedError;
}
