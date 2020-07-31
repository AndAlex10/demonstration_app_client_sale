import 'package:encrypt/encrypt.dart';

class Utils {


  static String encrypt (String text) {
    final key = Key.fromUtf8('3cdd3f7de306a725b9e24e243ef40564');
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static String decrypt (String text) {
    final key = Key.fromUtf8('3cdd3f7de306a725b9e24e243ef40564');
    final encrypter = Encrypter(AES(key));
    final iv = IV.fromLength(16);
    Encrypted encrypted = Encrypted.fromBase64(text);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

}
