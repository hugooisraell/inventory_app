import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseService {
  static Database? _db;

  // Singleton
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'pyme.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Crea las tablas
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT,
        last_name TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        quantity INTEGER,
        price REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        user_id INTEGER,
        date TEXT,
        quantity INTEGER,
        total REAL
      )
    ''');
  }

  // CRUD de productos

  // Insertar producto
  Future<int> addProduct(String name, int qty, double price) async {
    final db = await database;
    return await db.insert('products', {
      'name': name,
      'quantity': qty,
      'price': price,
    });
  }

  // Obtener todos los productos
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }

  // Actualizar producto
  Future<int> updateProduct(int id, String name, int qty, double price) async {
    final db = await database;
    return await db.update(
      'products',
      {'name': name, 'quantity': qty, 'price': price},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Eliminar producto
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD de ventas

  // Registrar venta
  Future<int> addSale(int productId, int userId, int qty, double total) async {
    final db = await database;
    return await db.insert('sales', {
      'product_id': productId,
      'user_id': userId,
      'date': DateTime.now().toIso8601String(),
      'quantity': qty,
      'total': total,
    });
  }

  // Obtener todas las ventas
  Future<List<Map<String, dynamic>>> getSales() async {
    final db = await database;
    return await db.query('sales');
  }

  // CRUD de Usuario

  // Registro
  Future<int> registerUser(
    String fstName,
    String lstName,
    String email,
    String pass,
  ) async {
    final db = await database;
    return await db.insert('users', {
      'first_name': fstName,
      'last_name': lstName,
      'email': email,
      'password': pass,
    });
  }

  // Login
  Future<Map<String, dynamic>?> login(String email, String pass) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, pass],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Comprueba si el email ya esta registrado
  Future<bool> emailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Actualizar usuario
  Future<int> updateUser(
    int id,
    String fstName,
    String lstName,
    String email,
  ) async {
    final db = await database;
    return await db.update(
      'users',
      {'first_name': fstName, 'last_name': lstName, 'email': email},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
