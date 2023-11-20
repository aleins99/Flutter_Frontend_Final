class Venta {
  int idVenta;
  DateTime fecha;
  String factura;
  double total;

  Venta({
    required this.idVenta,
    required this.fecha,
    required this.factura,
    required this.total,
  });

  // Convert a Venta into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    print(fecha.toIso8601String());
    return {
      'idVenta': idVenta,
      'fecha': fecha,
      'factura': factura,
      'total': total,
    };
  }

  // Convert a Map into a Venta. The keys must correspond to the names of the columns in the database.
  factory Venta.fromMap(Map<String, dynamic> map) {
    print(DateTime.parse(map['fecha']));
    return Venta(
      idVenta: map['idVenta'],
      fecha: DateTime.parse(map['fecha']),
      factura: map['factura'],
      total: map['total'],
    );
  }
}
