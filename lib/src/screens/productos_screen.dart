import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_frontend_final/src/models/categoria.dart';
import 'package:flutter_frontend_final/src/models/producto.dart';
import '../providers/database_helper.dart';

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  List<Producto> productos = [];
  List<Categoria> categorias = [];
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _codigo = TextEditingController();
  final TextEditingController _precio = TextEditingController();
  Categoria? selectedCategoria; // Categoria seleccionada





  @override
  void initState() {
    super.initState();
    _loadProductos();
    _loadCategorias();
  }

  void _loadProductos() async {
    productos = await DatabaseHelper.instance.retrieveProductos();
    setState(() {});
  }
  void _loadCategorias() async {
    categorias = await DatabaseHelper.instance.retrieveCategorias();
    print("Reservas cargadas: $categorias");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administración de Productos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nombre,
                  decoration: const InputDecoration(labelText: 'Nombre del producto'),
                ),
                TextField(
                  controller: _codigo,
                  decoration: const InputDecoration(labelText: 'Código del producto'),
                ),
                TextField(
                  controller: _precio,
                  decoration: const InputDecoration(labelText: 'Precio del producto'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<Categoria>(
                value: selectedCategoria,
                hint: const Text("Seleccione una categoria para el producto"),
                onChanged: (Categoria? newValue) {
                  setState(() {
                    selectedCategoria = newValue;
                  });
                },
                items:
                    categorias.map<DropdownMenuItem<Categoria>>((Categoria categoria) {
                  return DropdownMenuItem<Categoria>(
                    value: categoria,
                    child: Text(categoria.nombre),
                  );
                }).toList(),
              ),
            ),
          Row(
            children: [
              ElevatedButton(
                onPressed: _addProductos,
                child: const Text('Agregar'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(productos[index].nombre),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editProducto(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            _deleteProducto(productos[index].idProducto),
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

  void _addProductos() async {
    if (_nombre.text.isNotEmpty && selectedCategoria !=null && _precio.text.isNotEmpty && _codigo.text.isNotEmpty) {
      Producto newProducto = Producto(
          idProducto: 0,
          nombre: _nombre.text, 
          precio: double.parse(_precio.text), 
          categoria: selectedCategoria!, 
          codigo: _codigo.text, );
      await DatabaseHelper.instance.insertProducto(newProducto);
      _loadProductos();
      _nombre.clear();
      _codigo.clear();
      _precio.clear();
    }
  }

  void _deleteProducto(int id) async {
    await DatabaseHelper.instance.deleteProducto(id);
    _loadProductos();
  }

  void _editProducto(int index) async {
    _nombre.text = productos[index].nombre;
    _precio.text = productos[index].precio.toString();
    _codigo.text = productos[index].codigo;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Producto'),
          content: Column(children: [
            TextField(
              controller: _nombre,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
            controller: _precio,
            decoration: const InputDecoration(labelText: 'Precio'),
            keyboardType: TextInputType.number
          ),
          TextField(
            controller: _codigo,
            decoration: const InputDecoration(labelText: 'Codigo'),
          ),
           DropdownButton<Categoria>(
                value: selectedCategoria,
                hint: const Text("Seleccione una categoria"),
                onChanged: (Categoria? newValue) {
                  setState(() {
                    selectedCategoria = newValue;
                  });
                },
                items:
                    categorias.map<DropdownMenuItem<Categoria>>((Categoria categoria) {
                  return DropdownMenuItem<Categoria>(
                    value: categoria,
                    child: Text(categoria.nombre),
                  );
                }).toList(),
              ),
          ],),

          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
               if(_nombre.text.isNotEmpty && selectedCategoria !=null && _precio.text.isNotEmpty && _codigo.text.isNotEmpty) {
                  productos[index].nombre = _nombre.text;
                  productos[index].precio = double.parse(_precio.text);
                  productos[index].codigo = _codigo.text;
                  productos[index].categoria = selectedCategoria!;
                  await DatabaseHelper.instance.updateProducto(productos[index]);
                  _loadProductos();
                  Navigator.of(context).pop();
                  _nombre.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
