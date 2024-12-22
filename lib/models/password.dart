import '../helpers/encryption.dart';

class Password {
  final String userId;
  final String appName;
  final String username;
  final String password;

  Password({
    required this.userId,
    required this.appName,
    required this.username,
    required this.password,
  });

  // Convert a Password object into a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'app_name': appName,
      'username': username,
      'password': EncryptionHelper.encryptPassword(password, username),
    };
  }

  // Convert a Map into a Password object
  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      userId: map['user_id'],
      appName: map['app_name'],
      username: map['username'],
      password: EncryptionHelper.decryptPassword(map['password'], map['username']),
    );
  }
}
