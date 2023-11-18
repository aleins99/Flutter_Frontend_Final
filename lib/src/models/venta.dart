/* //para ventas
  static const _tableVentas = 'ventas';
  static const columnIdVenta = 'idVenta';
  static const columnFechaVenta = 'fecha';
  static const columnNumeroFactura = 'factura';
  static const columnTotalVenta = 'total';
*/
class Venta {
  int idVenta;
  String fecha;
  String factura;
  double total;

  Venta(
      {required this.idVenta,
      required this.fecha,
      required this.factura,
      required this.total});

  // Convert a Venta into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'idVenta': idVenta,
      'fecha': fecha,
      'factura': factura,
      'total': total,
    };
  }

  // Convert a Map into a Venta. The keys must correspond to the names of the columns in the database.
  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      idVenta: map['idVenta'],
      fecha: map['fecha'],
      factura: map['factura'],
      total: map['total'],
    );
  }
}
