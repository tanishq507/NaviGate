import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/location.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'locations.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE locations(
            id TEXT PRIMARY KEY,
            address TEXT,
            latitude REAL,
            longitude REAL,
            last_searched TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveLocation(Location location) async {
    final db = await database;
    await db.insert(
      'locations',
      location.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Location?> getLocation(String address) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'locations',
      where: 'address = ?',
      whereArgs: [address],
    );

    if (maps.isEmpty) return null;
    return Location.fromMap(maps.first);
  }

  Future<List<Location>> getRecentLocations({int limit = 10}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'locations',
      orderBy: 'last_searched DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) => Location.fromMap(maps[i]));
  }
}