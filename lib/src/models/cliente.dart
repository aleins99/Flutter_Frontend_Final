/*// para clientes
  static const _tableClientes = 'clientes';
  static const columnIdCliente = 'idCliente';
  static const columnNombreCliente = 'nombre';
  static const columnApellidoCliente = 'apellido';
  static const columnRucCliente = 'ruc';
  static const columnEmailCliente = 'email';
 */
class Cliente {
  int idCliente;
  String nombre;
  String apellido;
  String ruc;
  String email;

  Cliente(
      {required this.idCliente,
      required this.nombre,
      required this.apellido,
      required this.ruc,
      required this.email});

  // Convert a Cliente into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'idCliente': idCliente,
      'nombre': nombre,
      'apellido': apellido,
      'ruc': ruc,
      'email': email,
    };
  }

  // Convert a Map into a Cliente. The keys must correspond to the names of the columns in the database.
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      idCliente: map['idCliente'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      ruc: map['ruc'],
      email: map['email'],
    );
  }
}
