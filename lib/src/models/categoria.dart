class Categoria {
  int idCategoria;
  String nombre;

  Categoria({required this.idCategoria, required this.nombre});

  // Convert a Categoria into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'idCategoria': idCategoria,
      'nombre': nombre,
    };
  }

  // Convert a Map into a Categoria. The keys must correspond to the names of the columns in the database.
  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      idCategoria: map['idCategoria'],
      nombre: map['nombre'],
    );
  }
}
