import 'package:encrypt/encrypt.dart' as crypt;

class Crypter {
  static final key = crypt.Key.fromLength(32);
  static final iv = crypt.IV.fromLength(16);
  static final encrypter = crypt.Encrypter(crypt.AES(key));

  static String encryptAES(String text) {
    final crypted = encrypter.encrypt(text, iv: iv);
    return crypted.base64;
  }

  static String decryptAES(String encryptedtext) {
    final decrypted = encrypter.decrypt64(encryptedtext, iv: iv);
    return decrypted; 
  }
}