/* // para detalle venta: identificador del producto, cantidadDetalleVenta
  static const _tableDetalleVenta = 'detalleVenta';
  static const columnIdDetalleVenta = 'idDetalleVenta';
  static const columnidProductoDetalleDetalleVenta = 'idProductoDetalle';
  static const columncantidadDetalleVentaDetalleVenta = 'cantidadDetalleVenta';
*/
import '../models/producto.dart';
import '../models/venta.dart';

class DetalleVenta {
  int idDetalleVenta;
  Producto idProductoDetalle;
  int cantidadDetalle;
  Venta idVentaDetalle;

  DetalleVenta({
    required this.idDetalleVenta,
    required this.idVentaDetalle,
    required this.idProductoDetalle,
    required this.cantidadDetalle,
  });

  // Convert a DetalleVenta into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'idDetalleVenta': idDetalleVenta,
      'idVentaDetalle': idVentaDetalle,
      'idProductoDetalle': idProductoDetalle,
      'cantidadDetalle': cantidadDetalle,
    };
  }

  // Convert a Map into a DetalleVenta. The keys must correspond to the names of the columns in the database.
  factory DetalleVenta.fromMap(Map<String, dynamic> map) {
    return DetalleVenta(
      idDetalleVenta: map['idDetalleVenta'],
      idVentaDetalle: map['idVentaDetalle'],
      idProductoDetalle: map['idProductoDetalle'],
      cantidadDetalle: map['cantidadDetalle'],
    );
  }
}
