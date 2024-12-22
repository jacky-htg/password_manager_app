import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionHelper {
  static String encryptPassword(String password, String username) {
    final key = encrypt.Key.fromUtf8(_generateKey(username));
    
    // Membuat IV acak untuk enkripsi
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Enkripsi password
    final encrypted = encrypter.encrypt(password, iv: iv);
    
    // Gabungkan data terenkripsi dan IV yang digunakan, dikodekan dalam base64
    return '${encrypted.base64}:${iv.base64}';
  }

  static String decryptPassword(String encryptedPassword, String username) {
    // Pisahkan data terenkripsi dan IV dari string yang digabungkan
    final parts = encryptedPassword.split(':');
    final encryptedData = parts[0];
    final iv = encrypt.IV.fromBase64(parts[1]);
    
    // Membuat key dari username
    final key = encrypt.Key.fromUtf8(_generateKey(username));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Dekripsi password
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return decrypted;
  }

  static String _generateKey(String username) {
    final bytes = utf8.encode(username);
    final hash = sha256.convert(bytes);
    final keyBytes = hash.bytes.sublist(0, 16);
    return base64.encode(keyBytes);
  }
}
