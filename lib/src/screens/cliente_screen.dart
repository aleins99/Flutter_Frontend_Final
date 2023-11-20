import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../providers/database_helper.dart';

class ClienteScreen extends StatefulWidget {
  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  List<Cliente> clientes = [];
  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerApellido = TextEditingController();
  TextEditingController _controllerRuc = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  void _loadClientes() async {
    clientes = await DatabaseHelper.instance.retrieveClientes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Administración de Clientes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _controllerNombre,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _controllerApellido,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                ),
                TextField(
                  controller: _controllerRuc,
                  decoration: const InputDecoration(labelText: 'RUC'),
                ),
                TextField(
                  controller: _controllerEmail,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _addCliente,
                      child: const Text('Agregar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${clientes[index].nombre} ${clientes[index].apellido}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editCliente(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            _deleteCliente(clientes[index].idCliente),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addCliente() async {
    if (_controllerNombre.text.isNotEmpty &&
        _controllerApellido.text.length > 3 &&
        _controllerRuc.text.length > 3 &&
        _controllerEmail.text.length > 3) {
      Cliente newCliente = Cliente(
          idCliente: 0, // id 0 porque SQLite lo autoincrementará
          nombre: _controllerNombre.text,
          apellido: _controllerApellido.text,
          ruc: _controllerRuc.text,
          email: _controllerEmail.text);
      await DatabaseHelper.instance.insertCliente(newCliente);
      _loadClientes();
      _controllerNombre.clear();
      _controllerApellido.clear();
      _controllerRuc.clear();
      _controllerEmail.clear();
    }
  }

  void _deleteCliente(int id) async {
    await DatabaseHelper.instance.deleteCliente(id);
    _loadClientes();
  }

  void _editCliente(int index) async {
    _controllerNombre.text = clientes[index].nombre;
    _controllerApellido.text = clientes[index].apellido;
    _controllerRuc.text = clientes[index].ruc;
    _controllerEmail.text = clientes[index].email;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controllerNombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              TextField(
                controller: _controllerApellido,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                ),
              ),
              TextField(
                controller: _controllerRuc,
                decoration: const InputDecoration(
                  labelText: 'RUC',
                ),
              ),
              TextField(
                controller: _controllerEmail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Cliente updatedCliente = Cliente(
                    idCliente: clientes[index].idCliente,
                    nombre: _controllerNombre.text,
                    apellido: _controllerApellido.text,
                    ruc: _controllerRuc.text,
                    email: _controllerEmail.text);
                await DatabaseHelper.instance.updateCliente(updatedCliente);
                _loadClientes();
                Navigator.pop(context);
                _controllerNombre.clear();
                _controllerApellido.clear();
                _controllerRuc.clear();
                _controllerEmail.clear();
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }
}
