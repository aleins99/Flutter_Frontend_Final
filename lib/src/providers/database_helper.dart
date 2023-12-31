import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/categoria.dart';
import '../models/producto.dart';
import '../models/cliente.dart';
import '../models/venta.dart';
import '../models/detalle_venta.dart';

class DatabaseHelper {
  static const _dbName = 'SistemaVentas.db';
  static const _dbVersion = 2;

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
  static const columnVentaDetalleVenta = 'idVentaDetalle';
  static const columnProductoDetalleVenta = 'idProductoDetalle';
  static const columnCantidadDetalleVenta = 'cantidadDetalle';

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
    $columnCodigoProducto TEXT NOT NULL,
    FOREIGN KEY($columnCategoriaProducto) REFERENCES $_tableName($columnId)
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
    $columnVentaDetalleVenta INTEGER NOT NULL,
    $columnProductoDetalleVenta INTEGER NOT NULL,
    $columnCantidadDetalleVenta INTEGER NOT NULL,
    FOREIGN KEY ($columnVentaDetalleVenta) REFERENCES $_tableVentas ($columnIdVenta),
    FOREIGN KEY ($columnProductoDetalleVenta) REFERENCES $_tableProductos ($columnIdProducto)
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
  /*Future<int> insertProducto(Producto producto) async {
    Database db = await database;
    var map = producto.toMap();
    map.remove('idProducto'); // Remove the ID so SQLite can auto-generate it
    return await db.insert(_tableProductos, map);
  }*/

  Future<int> insertProducto(Producto producto) async {
    Database db = await database;
    var map = {
      'nombre': producto.nombre,
      'precio': producto.precio,
      'categoria': producto.categoria.idCategoria,
      'codigo': producto.codigo,
    };
    return await db.insert(_tableProductos,
        map); // Cambiado de 'FichaClinica' a '_tableFichaClinica'
  }

  Future<Categoria> obtenerCategoriaPorId(int id) async {
    Database db = await database;
    final res = await db.query(
      _tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (res.isNotEmpty) {
      return Categoria.fromMap(res.first);
    } else {
      throw Exception('Categoría no encontrada');
    }
  }

  /*Future<List<Producto>> retrieveProductos() async {
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
  }*/

  Future<List<Producto>> retrieveProductos() async {
    Database db = await database;
    final res = await db.query(
        _tableProductos); // Asegúrate de que _tableFichaClinica es el nombre correcto de tu tabla
    List<Producto> listaProductos = [];

    for (var fichaMap in res) {
      Categoria categoria =
          await obtenerCategoriaPorId(fichaMap[columnCategoriaProducto] as int);

      Producto producto = Producto.fromMap(fichaMap, categoria: categoria);
      listaProductos.add(producto);
    }

    return listaProductos;
  }

  Future<Producto> obtenerProductoPorId(int id) async {
    Database db = await database;
    final res = await db.query(
      _tableProductos,
      where: '$columnIdProducto = ?',
      whereArgs: [id],
    );

    if (res.isNotEmpty) {
      Categoria cat =
          await obtenerCategoriaPorId(res.first['categoria'] as int);
      return Producto.fromMap(res.first, categoria: cat);
    } else {
      throw Exception('Venta no encontrada');
    }
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
    Database db = await database;
    var map = cliente.toMap();
    map.remove('idCliente'); // Remove the ID so SQLite can auto-generate it
    return await db.insert(_tableClientes, map);
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
    Database db = await database;
    var map = venta.toMap();
    // format fecha
    map['fecha'] = DateTime.tryParse(venta.fecha.toString())!.toIso8601String();
    map.remove('idVenta'); // Remove the ID so SQLite can auto-generate it
    return await db.insert(_tableVentas, map);
  }

  Future<List<Venta>> retrieveVentas() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableVentas);
    List<Venta> ventas = [];
    for (var venta in maps) {
      double total = await totalVenta(venta['idVenta'] as int);
      Venta v = Venta(
        idVenta: venta['idVenta'] as int,
        fecha: DateTime.tryParse(venta['fecha'] as String)!,
        factura: venta['factura'] as String,
        total: total,
      );
      ventas.add(v);
    }
    return ventas;
  }

  Future<double> totalVenta(int idVenta) async {
    final db = await database;
    final res = await db.query(
      _tableDetalleVenta,
      where: '$columnVentaDetalleVenta = ?',
      whereArgs: [idVenta],
    );
    double total = 0.0;
    for (var detalle in res) {
      Producto producto =
          await obtenerProductoPorId(detalle['idProductoDetalle'] as int);
      total += producto.precio * (detalle['cantidadDetalle'] as int);
    }
    return total;
  }

  Future<Venta> obtenerVentaPorId(int id) async {
    Database db = await database;
    final res = await db.query(
      _tableVentas,
      where: '$columnIdVenta = ?',
      whereArgs: [id],
    );

    if (res.isNotEmpty) {
      return Venta.fromMap(res.first);
    } else {
      throw Exception('Venta no encontrada');
    }
  }

  Future<int> updateVenta(Venta venta) async {
    Database db = await instance.database;
    double newTotal = await totalVenta(venta.idVenta);
    venta.total = newTotal;
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
    Database db = await database;
    var map = detalleVenta.toMap();
    map['idProductoDetalle'] = detalleVenta.idProductoDetalle.idProducto;
    map['idVentaDetalle'] = detalleVenta.idVentaDetalle.idVenta;
    map.remove(
        'idDetalleVenta'); // Remove the ID so SQLite can auto-generate it
    updateVenta(detalleVenta.idVentaDetalle);
    return await db.insert(_tableDetalleVenta, map);
  }

  Future<List<DetalleVenta>> retrieveDetalleVentas() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableDetalleVenta);
    return List.generate(maps.length, (i) {
      return DetalleVenta(
        idDetalleVenta: maps[i][columnIdDetalleVenta],
        idVentaDetalle: maps[i][columnVentaDetalleVenta],
        idProductoDetalle: maps[i][columnProductoDetalleVenta],
        cantidadDetalle: maps[i][columnCantidadDetalleVenta],
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

  Future<List<DetalleVenta>> retrieveDetallesVenta(int idVenta) async {
    final db = await database;
    final res = await db.query(
      _tableDetalleVenta,
      where: '$columnVentaDetalleVenta = ?',
      whereArgs: [idVenta],
    );
    List<DetalleVenta> detallesVenta = [];

    for (var detalle in res) {
      Venta venta = await obtenerVentaPorId(detalle['idVentaDetalle'] as int);
      Producto producto =
          await obtenerProductoPorId(detalle['idProductoDetalle'] as int);
      DetalleVenta d = DetalleVenta(
        idDetalleVenta: detalle['idDetalleVenta'] as int,
        idVentaDetalle: venta,
        idProductoDetalle: producto,
        cantidadDetalle: detalle['cantidadDetalle'] as int,
      );
      detallesVenta.add(d);
    }
    return detallesVenta;
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
