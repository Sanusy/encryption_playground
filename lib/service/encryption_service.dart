import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';

enum _PrivateKeyComponentsKeys {
  modulus,
  exponent,
  p,
  q,
  aesKey,
  aesIv,
}

class EncryptionService {
  late final FlutterSecureStorage _storage;

  EncryptionService() {
    _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ));
  }

  Future<bool> get isKeyGenerated =>
      _storage.containsKey(key: _PrivateKeyComponentsKeys.modulus.name);

  Future<RSAPublicKey> generateUserKeys() async {
    final secureRandom = SecureRandom('Fortuna');

    secureRandom.seed(
      KeyParameter(
        Uint8List.fromList(
          List.generate(
            32,
            (_) => Random.secure().nextInt(255),
          ),
        ),
      ),
    );

    final keyGenerator = RSAKeyGenerator()
      ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(
          BigInt.parse('65537'),
          2048,
          64,
        ),
        secureRandom,
      ));

    final keys = keyGenerator.generateKeyPair();

    final publicKey = keys.publicKey as RSAPublicKey;
    final privateKey = keys.privateKey as RSAPrivateKey;

    await Future.wait([
      _storage.write(
          key: _PrivateKeyComponentsKeys.modulus.name,
          value: privateKey.modulus.toString()),
      _storage.write(
          key: _PrivateKeyComponentsKeys.exponent.name,
          value: privateKey.exponent.toString()),
      _storage.write(
          key: _PrivateKeyComponentsKeys.p.name,
          value: privateKey.p.toString()),
      _storage.write(
          key: _PrivateKeyComponentsKeys.q.name,
          value: privateKey.q.toString()),
    ]);

    final aesKey = Uint8List.fromList(
      List.generate(
        32,
        (_) => Random.secure().nextInt(255),
      ),
    );

    final aesIv = Uint8List.fromList(
      List.generate(
        16,
        (_) => Random.secure().nextInt(255),
      ),
    );

    await Future.wait([
      _storage.write(
          key: _PrivateKeyComponentsKeys.aesKey.name,
          value: base64.encode(aesKey)),
      _storage.write(
          key: _PrivateKeyComponentsKeys.aesIv.name,
          value: base64.encode(aesIv)),
    ]);

    return publicKey;
  }

  String encryptRsa(RSAPublicKey userKey, String message) {
    Uint8List dataToEncode = Uint8List.fromList(utf8.encode(message));

    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(userKey)); // true=encrypt

    final encodedBytes = _processInBlocks(encryptor, dataToEncode);
    return base64.encode(encodedBytes);
  }

  Future<String> decryptRsa(String encodedMessage) async {
    final modulus = await _storage.read(
      key: _PrivateKeyComponentsKeys.modulus.name,
    );
    final exponent = await _storage.read(
      key: _PrivateKeyComponentsKeys.exponent.name,
    );
    final p = await _storage.read(
      key: _PrivateKeyComponentsKeys.p.name,
    );
    final q = await _storage.read(
      key: _PrivateKeyComponentsKeys.q.name,
    );

    final privateKey = RSAPrivateKey(BigInt.parse(modulus!),
        BigInt.parse(exponent!), BigInt.parse(p!), BigInt.parse(q!));

    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false,
          PrivateKeyParameter<RSAPrivateKey>(privateKey)); // false=decrypt

    final decodedBytes =
        _processInBlocks(decryptor, base64.decode(encodedMessage));

    return utf8.decode(decodedBytes);
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

  Future<String> aesEncrypt(String message) async {
    final aesKeyBase64 =
        await _storage.read(key: _PrivateKeyComponentsKeys.aesKey.name);
    final aesIvBase64 =
        await _storage.read(key: _PrivateKeyComponentsKeys.aesIv.name);

    final aesKey = base64.decode(aesKeyBase64!);
    final aesIv = base64.decode(aesIvBase64!);

    final cipher = CBCBlockCipher(AESEngine());
    List<int> encodedMessage = utf8.encode(message);

    final ivParams = ParametersWithIV(KeyParameter(aesKey), aesIv);
    final paddingParams = PaddedBlockCipherParameters<
        ParametersWithIV<KeyParameter>, KeyParameter>(ivParams, null);
    final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddedCipher.init(true, paddingParams);

    return base64
        .encode(paddedCipher.process(Uint8List.fromList(encodedMessage)));
  }

  Future<String> aesDecrypt(String encryptedMessage) async {
    final aesKeyBase64 =
        await _storage.read(key: _PrivateKeyComponentsKeys.aesKey.name);
    final aesIvBase64 =
        await _storage.read(key: _PrivateKeyComponentsKeys.aesIv.name);

    final aesKey = base64.decode(aesKeyBase64!);
    final aesIv = base64.decode(aesIvBase64!);

    final cipher = CBCBlockCipher(AESEngine());

    final encryptedMessageBytes = base64.decode(encryptedMessage);

    final ivParams =
        ParametersWithIV<KeyParameter>(KeyParameter(aesKey), aesIv);

    final paddingParams = PaddedBlockCipherParameters<
        ParametersWithIV<KeyParameter>, KeyParameter>(
      ivParams,
      null,
    );
    final paddingCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddingCipher.init(false, paddingParams);
    final decryptedMessageBytes = paddingCipher.process(encryptedMessageBytes);
    final decryptedMessage = utf8.decode(decryptedMessageBytes);

    return decryptedMessage;
  }

  Future<void> clearKeys() {
    return _storage.deleteAll();
  }
}
