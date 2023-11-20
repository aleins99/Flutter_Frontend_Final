/* // para detalle venta: identificador del producto, cantidad
  static const _tableDetalleVenta = 'detalleVenta';
  static const columnIdDetalleVenta = 'idDetalleVenta';
  static const columnIdProductoDetalleVenta = 'idProducto';
  static const columnCantidadDetalleVenta = 'cantidad';
*/
import '../models/producto.dart';
import '../models/venta.dart';

class DetalleVenta {
  int idDetalleVenta;
  Producto producto;
  int cantidad;
  Venta venta;

  DetalleVenta(
      {required this.idDetalleVenta,
      required this.producto,
      required this.cantidad,
      required this.venta});

  // Convert a DetalleVenta into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'idDetalleVenta': idDetalleVenta,
      'producto': producto,
      'cantidad': cantidad,
      'venta': venta,
    };
  }

  // Convert a Map into a DetalleVenta. The keys must correspond to the names of the columns in the database.
  factory DetalleVenta.fromMap(Map<String, dynamic> map) {
    return DetalleVenta(
      idDetalleVenta: map['idDetalleVenta'],
      producto: map['producto'],
      cantidad: map['cantidad'],
      venta: map['venta'],
    );
  }
}
