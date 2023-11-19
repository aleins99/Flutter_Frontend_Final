import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/categoria.dart';
import '../models/producto.dart';
import '../models/cliente.dart';
import '../models/venta.dart';
import '../models/detalle_venta.dart';

class DatabaseHelper {
  static const _dbName = 'SistemaVentas.db';
  static const _dbVersion = 1;

  static const _tableName = 'categorias';
  static const columnId = 'idCategoria';
  static const columnNombre = 'nombre';
  // Métodos para administración de categorías

  // para productos
  static const _tableProductos = 'productos';
  static const columnIdProducto = 'idProducto';
  static const columnNombreProducto = 'nombre';
  static const columnPrecioProducto = 'precio';
  static const columnCategoriaProducto = 'categoria';
  static const columnCodigoProducto = 'codigo';

  // para clientes
  static const _tableClientes = 'clientes';
  static const columnIdCliente = 'idCliente';
  static const columnNombreCliente = 'nombre';
  static const columnApellidoCliente = 'apellido';
  static const columnRucCliente = 'ruc';
  static const columnEmailCliente = 'email';

  //para ventas
  static const _tableVentas = 'ventas';
  static const columnIdVenta = 'idVenta';
  static const columnFechaVenta = 'fecha';
  static const columnNumeroFactura = 'factura';
  static const columnTotalVenta = 'total';

  // para detalle venta: identificador del producto, cantidad
  static const _tableDetalleVenta = 'detalleVenta';
  static const columnIdDetalleVenta = 'idDetalleVenta';
  static const columnIdProductoDetalleVenta = 'idProducto';
  static const columnCantidadDetalleVenta = 'cantidad';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnNombre TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE $_tableProductos (
    $columnIdProducto INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnNombreProducto TEXT NOT NULL,
    $columnPrecioProducto REAL NOT NULL,
    $columnCategoriaProducto INTEGER NOT NULL,
    $columnCodigoProducto TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE $_tableClientes (
    $columnIdCliente INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnNombreCliente TEXT NOT NULL,
    $columnApellidoCliente TEXT NOT NULL,
    $columnRucCliente TEXT NOT NULL,
    $columnEmailCliente TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE $_tableVentas (
    $columnIdVenta INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnFechaVenta TEXT NOT NULL,
    $columnNumeroFactura TEXT NOT NULL,
    $columnTotalVenta REAL NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE $_tableDetalleVenta (
    $columnIdDetalleVenta INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnIdVenta INTEGER NOT NULL,
    $columnIdProductoDetalleVenta INTEGER NOT NULL,
    $columnCantidadDetalleVenta INTEGER NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $_tableDetalleVenta (
    $columnIdDetalleVenta INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnIdProductoDetalleVenta INTEGER NOT NULL,
    $columnCantidadDetalleVenta INTEGER NOT NULL
    )
    ''');
  }

  // CRUD para categorías
  Future<int> insertCategoria(Categoria categoria) async {
    Database db = await database;
    var map = categoria.toMap();
    map.remove('idCategoria'); // Remove the ID so SQLite can auto-generate it
    return await db.insert(_tableName, map);
  }

  Future<List<Categoria>> retrieveCategorias() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Categoria(
        idCategoria: maps[i][columnId],
        nombre: maps[i][columnNombre],
      );
    });
  }

  Future<int> updateCategoria(Categoria categoria) async {
    Database db = await instance.database;
    return await db.update(
      _tableName,
      categoria.toMap(),
      where: '$columnId = ?',
      whereArgs: [categoria.idCategoria],
    );
  }

  Future<int> deleteCategoria(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  //CRUD para productos
  Future<int> insertProducto(Producto producto) async {
    Database db = await instance.database;
    return await db.insert(_tableProductos, producto.toMap());
  }

  Future<List<Producto>> retrieveProductos() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableProductos);
    return List.generate(maps.length, (i) {
      return Producto(
        idProducto: maps[i][columnIdProducto],
        nombre: maps[i][columnNombreProducto],
        precio: maps[i][columnPrecioProducto],
        categoria: maps[i][columnCategoriaProducto],
        codigo: maps[i][columnCodigoProducto],
      );
    });
  }

  Future<int> updateProducto(Producto producto) async {
    Database db = await instance.database;
    return await db.update(
      _tableProductos,
      producto.toMap(),
      where: '$columnIdProducto = ?',
      whereArgs: [producto.idProducto],
    );
  }

  Future<int> deleteProducto(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _tableProductos,
      where: '$columnIdProducto = ?',
      whereArgs: [id],
    );
  }

  //CRUD para clientes
  Future<int> insertCliente(Cliente cliente) async {
    Database db = await instance.database;
    return await db.insert(_tableClientes, cliente.toMap());
  }

  Future<List<Cliente>> retrieveClientes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableClientes);
    return List.generate(maps.length, (i) {
      return Cliente(
        idCliente: maps[i][columnIdCliente],
        nombre: maps[i][columnNombreCliente],
        apellido: maps[i][columnApellidoCliente],
        ruc: maps[i][columnRucCliente],
        email: maps[i][columnEmailCliente],
      );
    });
  }

  Future<int> updateCliente(Cliente cliente) async {
    Database db = await instance.database;
    return await db.update(
      _tableClientes,
      cliente.toMap(),
      where: '$columnIdCliente = ?',
      whereArgs: [cliente.idCliente],
    );
  }

  Future<int> deleteCliente(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _tableClientes,
      where: '$columnIdCliente = ?',
      whereArgs: [id],
    );
  }

  //CRUD para ventas
  Future<int> insertVenta(Venta venta) async {
    Database db = await instance.database;
    return await db.insert(_tableVentas, venta.toMap());
  }

  Future<List<Venta>> retrieveVentas() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableVentas);
    return List.generate(maps.length, (i) {
      return Venta(
        idVenta: maps[i][columnIdVenta],
        fecha: maps[i][columnFechaVenta],
        factura: maps[i][columnNumeroFactura],
        total: maps[i][columnTotalVenta],
      );
    });
  }

  Future<int> updateVenta(Venta venta) async {
    Database db = await instance.database;
    return await db.update(
      _tableVentas,
      venta.toMap(),
      where: '$columnIdVenta = ?',
      whereArgs: [venta.idVenta],
    );
  }

  Future<int> deleteVenta(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _tableVentas,
      where: '$columnIdVenta = ?',
      whereArgs: [id],
    );
  }

  //CRUD para detalle venta
  Future<int> insertDetalleVenta(DetalleVenta detalleVenta) async {
    Database db = await instance.database;
    return await db.insert(_tableDetalleVenta, detalleVenta.toMap());
  }

  Future<List<DetalleVenta>> retrieveDetalleVentas() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableDetalleVenta);
    return List.generate(maps.length, (i) {
      return DetalleVenta(
        idDetalleVenta: maps[i][columnIdDetalleVenta],
        idVenta: maps[i][columnIdVenta],
        idProducto: maps[i][columnIdProductoDetalleVenta],
        cantidad: maps[i][columnCantidadDetalleVenta],
      );
    });
  }

  Future<int> updateDetalleVenta(DetalleVenta detalleVenta) async {
    Database db = await instance.database;
    return await db.update(
      _tableDetalleVenta,
      detalleVenta.toMap(),
      where: '$columnIdDetalleVenta = ?',
      whereArgs: [detalleVenta.idDetalleVenta],
    );
  }

  Future<int> deleteDetalleVenta(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _tableDetalleVenta,
      where: '$columnIdDetalleVenta = ?',
      whereArgs: [id],
    );
  }
}
