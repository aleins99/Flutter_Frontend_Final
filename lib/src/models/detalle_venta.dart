/* // para detalle venta: identificador del producto, cantidadVenta
  static const _tableDetalleVenta = 'detalleVenta';
  static const columnIdDetalleVenta = 'idDetalleVenta';
  static const columnIdProductoDetalleVenta = 'idProducto';
  static const columncantidadVentaDetalleVenta = 'cantidadVenta';
*/
import '../models/producto.dart';
import '../models/venta.dart';

class DetalleVenta {
  int idDetalleVenta;
  Producto idProducto;
  int cantidad;
  Venta idVenta;

  DetalleVenta({
    required this.idDetalleVenta,
    required this.idVenta,
    required this.idProducto,
    required this.cantidad,
  });

  // Convert a DetalleVenta into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'idDetalleVenta': idDetalleVenta,
      'idVenta': idVenta,
      'idProducto': idProducto,
      'cantidad': cantidad,
    };
  }

  // Convert a Map into a DetalleVenta. The keys must correspond to the names of the columns in the database.
  factory DetalleVenta.fromMap(Map<String, dynamic> map) {
    return DetalleVenta(
      idDetalleVenta: map['idDetalleVenta'],
      idVenta: map['idVenta'],
      idProducto: map['idProducto'],
      cantidad: map['cantidad'],
    );
  }
}
