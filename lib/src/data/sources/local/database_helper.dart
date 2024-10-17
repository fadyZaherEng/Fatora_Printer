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
      'CREATE TABLE fatories (id INTEGER PRIMARY KEY AUTOINCREMENT, paymentMethod TEXT, fatoraId TEXT, name TEXT, date TEXT, time TEXT, '
          'price TEXT, numberArrived TEXT, numberMove TEXT, status TEXT, statusSuccess TEXT, deviceNumber TEXT, traderNumber TEXT)',
    );
  }

  // Insert a fatora into the database
  Future<int> insertFatora(Fatora fatora) async {
    final db = await database;
    return await db.insert(
      'fatories',
      fatora.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all fatoras from the database
  Future<List<Fatora>> getFatora() async {
    final db = await database;  // Ensure the database is opened properly

    // Perform a query and order results by the 'name' column in ascending order
    final List<Map<String, dynamic>> maps = await db.query(
      'fatories',
      orderBy: 'name ASC',  // Use the 'ORDER BY' clause to sort by name in ascending order
    );
     print("length: ${maps.length}");
    // Check if maps is not null and contains data
    if (maps.isNotEmpty) {
      // Generate and return the list of Fatora objects
      return maps.map((map) => Fatora.fromJson(map)).toList();
    } else {
      // Return an empty list if no records are found
      return <Fatora>[];
    }
  }

  // Delete a fatora from the database
  Future<int> deleteFatora(int id) async {
    final db = await database;
    return await db.delete(
      'fatories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update a fatora in the database
  Future<int> updateFatora(Fatora fatora) async {
    final db = await database;
    return await db.update(
      'fatories',
      fatora.toJson(),
      where: 'id = ?',
      whereArgs: [fatora.id],
    );
  }

  // Close the database
  Future close() async {
    final db = await database;
    db.close();
  }
}
