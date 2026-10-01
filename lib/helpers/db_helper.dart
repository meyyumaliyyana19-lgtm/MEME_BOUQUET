import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'toko_digital.db');

    return await openDatabase(
      path,
      version: 3, // Naikkan versi ke 3 untuk menambahkan tabel cart
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS cart (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              productName TEXT UNIQUE,
              quantity INTEGER
            )
          ''');
        }
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        imageUrl TEXT,
        description TEXT,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        totalPrice REAL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productName TEXT UNIQUE,
        quantity INTEGER
      )
    ''');
  }

  // --- SINKRONISASI KERANJANG PERMANEN ---
  static Future<void> saveCartItem(String productName, int quantity) async {
    final dbClient = await db;
    await dbClient.insert(
      'cart',
      {'productName': productName, 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeCartItem(String productName) async {
    final dbClient = await db;
    await dbClient.delete(
      'cart',
      where: 'productName = ?',
      whereArgs: [productName],
    );
  }

  static Future<List<Map<String, dynamic>>> getCartData() async {
    final dbClient = await db;
    return await dbClient.query('cart');
  }

  static Future<void> clearCartData() async {
    final dbClient = await db;
    await dbClient.delete('cart');
  }

  // --- SINKRONISASI PRODUK BAWAAN ---
  static Future<void> syncMissingProducts() async {
    final dbClient = await db;

    List<Map<String, dynamic>> defaultProducts = [
      {
        'name': 'Bouquet Pita Satin 10 Tangkai',
        'price': 100000.0,
        'imageUrl': 'assets/images/bouquet1.jpg',
        'description': 'Buket mawar buatan tangan dari pita satin kualitas tinggi isi 10 tangkai.',
        'category': 'Pita Satin',
      },
      {
        'name': 'Bouquet Pita Satin 7 Tangkai',
        'price': 75000.0,
        'imageUrl': 'assets/images/bouquet2.jpg',
        'description': 'Buket pita satin isi 7 tangkai dengan hiasan pita cantik.',
        'category': 'Pita Satin',
      },
      {
        'name': 'Buket Jajan Paket 2',
        'price': 70000.0,
        'imageUrl': 'assets/images/bouquet1.jpg',
        'description': 'Buket snack lezat yang diisi berbagai macam makanan ringan.',
        'category': 'Buket Jajan',
      },
      {
        'name': 'Buket Jajan Paket 2 Blue',
        'price': 70000.0,
        'imageUrl': 'assets/images/bouquet7.jpg',
        'description': 'Buket Mix 2 Blue berisi aneka jajanan favorit.',
        'category': 'Buket Jajan',
      },
      {
        'name': 'Bouquet Pita Satin 7 tangkai mix uang',
        'price': 100000.0,
        'imageUrl': 'assets/images/bouquet8.jpg',
        'description': 'Buket satin isi 7 tangkai dengan tambahan uang.',
        'category': 'Pita Satin',
      },
      {
        'name': 'Buket Jajan Paket Mini',
        'price': 70000.0,
        'imageUrl': 'assets/images/bouquet9.jpg',
        'description': 'Buket Jajan Paket Mini berisi aneka jajanan.',
        'category': 'Buket Jajan',
      },
      {
        'name': 'Buket bunga mix pink',
        'price': 70000.0,
        'imageUrl': 'assets/images/bouquet10.jpg',
        'description': 'Buket bunga dengan perpaduan warna pink, putih, dan merah.',
        'category': 'Bunga Segar',
      },
      {
        'name': 'Buket rokok',
        'price': 70000.0,
        'imageUrl': 'assets/images/bouquet11.jpg',
        'description': 'Buket Rokok Sukun Executive.',
        'category': 'Bunga Segar',
      },
    ];

    for (var prod in defaultProducts) {
      List<Map> existing = await dbClient.query(
        'products',
        where: 'name = ?',
        whereArgs: [prod['name']],
      );
      if (existing.isEmpty) {
        await dbClient.insert('products', prod);
      }
    }
  }

  static Future<int> insertProduct(ProductModel product) async {
    final dbClient = await db;
    return await dbClient.insert('products', product.toMap());
  }

  static Future<List<ProductModel>> getProducts() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('products');
    return maps.map((e) => ProductModel.fromMap(e)).toList();
  }

  static Future<int> insertOrder(OrderHistory order) async {
    final dbClient = await db;
    return await dbClient.insert('orders', order.toMap());
  }

  static Future<List<OrderHistory>> getOrders() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient.query('orders', orderBy: 'id DESC');
    return maps.map((e) => OrderHistory.fromMap(e)).toList();
  }
}