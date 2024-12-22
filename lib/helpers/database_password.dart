import 'package:sqflite/sqflite.dart';
import 'database.dart';
import '../models/password.dart';

class PasswordDatabaseHelper {
  // Add or update a password
  static Future<void> addPassword(Password password) async {
    final db = await DatabaseHelper.initializeDatabase();
    await db.insert(
      'passwords',
      password.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all passwords
  static Future<List<Password>> fetchPasswords() async {
    final db = await DatabaseHelper.initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query('passwords');

    return List.generate(
      maps.length,
      (i) => Password.fromMap(maps[i]),
    );
  }

  // Delete a password by userId and appName
  static Future<void> deletePassword(String userId, String appName) async {
    final db = await DatabaseHelper.initializeDatabase();
    await db.delete(
      'passwords',
      where: 'user_id = ? AND app_name = ?',
      whereArgs: [userId, appName],
    );
  }
}
