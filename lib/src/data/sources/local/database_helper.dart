import 'package:fatora/src/domain/entities/fatora.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)',
    );
  }

  // Insert a user into the database
  Future<int> insertFatora(Fatora user) async {
    final db = await database;
    return await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all users from the database
  Future<List<Fatora>> getFatora() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return Fatora.fromJson(maps[i]);
    });
  }

  // Update a user in the database
  // Future<int> updateFatora(Fatora user) async {
  //   final db = await database;
  //   return await db.update(
  //     'users',
  //     user.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [user.id],
  //   );
  // }

  // Delete a user from the database
  Future<int> deleteFatora(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future close() async {
    final db = await database;
    db.close();
  }
}
