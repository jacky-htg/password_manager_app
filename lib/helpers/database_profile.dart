import 'package:sqflite/sqflite.dart';
import '../models/profile.dart';
import 'database.dart';

class ProfileDatabaseHelper {
  static Future<void> addProfile(Profile profile) async {
    final db = await DatabaseHelper.initializeDatabase();
    await db.insert(
      'profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Profile>> fetchProfiles() async {
    final db = await DatabaseHelper.initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query('profiles');

    return List.generate(
      maps.length,
      (i) => Profile.fromMap(maps[i]),
    );
  }

  static Future<void> deleteProfile(String userId) async {
    final db = await DatabaseHelper.initializeDatabase();
    await db.delete(
      'profiles',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
