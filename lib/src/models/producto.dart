/*
// para productos
  static const _tableProductos = 'productos';
  static const columnIdProducto = 'idProducto';
  static const columnNombreProducto = 'nombre';
  static const columnPrecioProducto = 'precio';
  static const columnCategoriaProducto = 'categoria';
  static const columnCodigoProducto = 'codigo';

*/
import 'package:flutter_frontend_final/src/models/categoria.dart';

class Producto {
  int idProducto;
  String nombre;
  double precio;
  Categoria categoria;
  String codigo;

  Producto(
      {required this.idProducto,
      required this.nombre,
      required this.precio,
      required this.categoria,
      required this.codigo});

  // Convert a Producto into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'precio': precio,
      'categoria': categoria,
      'codigo': codigo,
    };
  }

  // Convert a Map into a Producto. The keys must correspond to the names of the columns in the database.
  factory Producto.fromMap(Map<String, dynamic> map,{required Categoria categoria}) {
    return Producto(
      idProducto: map['idProducto'],
      nombre: map['nombre'],
      precio: map['precio'],
      categoria: categoria,
      codigo: map['codigo'],
    );
  }
}
