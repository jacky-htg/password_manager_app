import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'profile.db');
    print('Database path: $path');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE profiles(user_id TEXT PRIMARY KEY, username TEXT, full_name TEXT, password TEXT)',
        );
        db.execute(
          'CREATE TABLE passwords(user_id TEXT, app_name TEXT, username TEXT, password TEXT, PRIMARY KEY(user_id, app_name))',
        );
      },
    );
  }
}