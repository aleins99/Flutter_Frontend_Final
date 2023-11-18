/* // para detalle venta: identificador del producto, cantidad
  static const _tableDetalleVenta = 'detalleVenta';
  static const columnIdDetalleVenta = 'idDetalleVenta';
  static const columnIdProductoDetalleVenta = 'idProducto';
  static const columnCantidadDetalleVenta = 'cantidad';
*/
class DetalleVenta {
  int idDetalleVenta;
  int idVenta;
  int idProducto;
  int cantidad;

  DetalleVenta(
      {required this.idDetalleVenta,
      required this.idVenta,
      required this.idProducto,
      required this.cantidad});

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
