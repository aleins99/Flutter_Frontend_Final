import 'package:flutter/material.dart';
import '../models/detalle_venta.dart';
import '../models/producto.dart';
import '../models/venta.dart';

import '../providers/database_helper.dart';

class DetalleVentaScreen extends StatefulWidget {
  @override
  _DetalleVentaScreenState createState() => _DetalleVentaScreenState();
}

class _DetalleVentaScreenState extends State<DetalleVentaScreen> {
  List<DetalleVenta> detalleVenta = [];
  List<Producto> productos = [];
  Producto? selectedProducto;
  List<Venta> ventas = [];
  Venta? selectedVenta;
  TextEditingController _controllerCantidad = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loaddetalleVenta();
  }

  void _loaddetalleVenta() async {
    detalleVenta = await DatabaseHelper.instance.retrieveDetalleVentas();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Administración de DetalleVenta')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButton<Venta>(
                  value: selectedVenta,
                  hint: Text("Seleccione la venta"),
                  onChanged: (Venta? newValue) {
                    setState(() {
                      selectedVenta = newValue;
                    });
                  },
                  items: ventas.map<DropdownMenuItem<Venta>>((Venta venta) {
                    return DropdownMenuItem<Venta>(
                      value: venta,
                      child: Text(
                        '${venta.fecha} ${venta.total}',
                      ),
                    );
                  }).toList(),
                ),
                DropdownButton<Producto>(
                  value: selectedProducto,
                  hint: Text("Seleccione un Producto"),
                  onChanged: (Producto? newValue) {
                    setState(() {
                      selectedProducto = newValue;
                    });
                  },
                  items: productos
                      .map<DropdownMenuItem<Producto>>((Producto producto) {
                    return DropdownMenuItem<Producto>(
                      value: producto,
                      child: Text(
                        '${producto.nombre} ${producto.precio}',
                      ),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: _controllerCantidad,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _addDetalleVenta,
                      child: const Text('Agregar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: detalleVenta.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${detalleVenta[index].producto.nombre} ${detalleVenta[index].cantidad}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editDetalleVenta(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteDetalleVenta(
                            detalleVenta[index].idDetalleVenta),
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

  void _addDetalleVenta() async {
    if (_controllerCantidad.text.isNotEmpty && selectedProducto != null) {
      DetalleVenta newDetalleVenta = DetalleVenta(
          idDetalleVenta: 0, // id 0 porque SQLite lo autoincrementará
          venta: selectedVenta!,
          producto: selectedProducto!,
          cantidad: int.parse(_controllerCantidad.text));
      await DatabaseHelper.instance.insertDetalleVenta(newDetalleVenta);
      _loaddetalleVenta();
      _controllerCantidad.clear();
    }
  }

  void _deleteDetalleVenta(int id) async {
    await DatabaseHelper.instance.deleteDetalleVenta(id);
    _loaddetalleVenta();
  }

  void _editDetalleVenta(int index) async {
    _controllerCantidad.text = detalleVenta[index].cantidad.toString();
    selectedProducto = detalleVenta[index].producto;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar DetalleVenta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controllerCantidad,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                ),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<Producto>(
                value: selectedProducto,
                hint: Text("Seleccione un Producto"),
                onChanged: (Producto? newValue) {
                  setState(() {
                    selectedProducto = newValue;
                  });
                },
                items: productos
                    .map<DropdownMenuItem<Producto>>((Producto producto) {
                  return DropdownMenuItem<Producto>(
                    value: producto,
                    child: Text(
                      '${producto.nombre} ${producto.precio}',
                    ),
                  );
                }).toList(),
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
                DetalleVenta updatedDetalleVenta = DetalleVenta(
                    idDetalleVenta: detalleVenta[index].idDetalleVenta,
                    venta: detalleVenta[index].venta,
                    producto: selectedProducto!,
                    cantidad: int.parse(_controllerCantidad.text));
                await DatabaseHelper.instance
                    .updateDetalleVenta(updatedDetalleVenta);
                _loaddetalleVenta();
                Navigator.pop(context);
                _controllerCantidad.clear();
                selectedProducto = null;
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }
}
