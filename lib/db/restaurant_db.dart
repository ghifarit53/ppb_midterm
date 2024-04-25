import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/restaurant.dart';

class RestaurantDatabase {
  static final RestaurantDatabase instance = RestaurantDatabase._init();

  static Database? _database;

  RestaurantDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE restaurant ( 
  id $idType, 
  name $textType
  dateAdded $textType
  rating $integerType,
  address $textType
)
''');
  }

  Future<Restaurant> insert(Restaurant restaurant) async {
    // Get a reference to the database.
    final db = await instance.database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    final id = await db.insert(
      'restaurant',
      restaurant.toJSON(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return restaurant.copy(id: id);
  }

  Future<Restaurant> get(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'restaurant',
      columns: ['id', 'name', 'dateAdded', 'rating', 'address'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Restaurant.fromJSON(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Restaurant>> getAll() async {
    final db = await instance.database;

    const orderBy = 'dateAdded ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query('restaurant', orderBy: orderBy);

    return result.map((json) => Restaurant.fromJSON(json)).toList();
  }

  Future<int> update(Restaurant restaurant) async {
    final db = await instance.database;

    return db.update(
      'restaurant',
      restaurant.toJSON(),
      where: 'id = ?',
      whereArgs: [restaurant.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'restaurant',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
