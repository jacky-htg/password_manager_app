import '../helpers/encryption.dart';

class Profile {
  final String userId;
  final String username;
  final String fullName;
  final String password;

  Profile({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'full_name': fullName,
      'password': EncryptionHelper.encryptPassword(password, username),
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      userId: map['user_id'],
      username: map['username'],
      fullName: map['full_name'],
      password: EncryptionHelper.decryptPassword(map['password'], map['username']),
    );
  }
}
