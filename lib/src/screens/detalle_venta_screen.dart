import 'package:flutter/material.dart';
import '../models/detalle_venta.dart';
import '../models/producto.dart';
import '../models/venta.dart';

import '../providers/database_helper.dart';

class DetalleVentaScreen extends StatefulWidget {
  final Venta venta;
  const DetalleVentaScreen({super.key, required this.venta});
  @override
  // ignore: library_private_types_in_public_api
  _DetalleVentaScreenState createState() => _DetalleVentaScreenState();
  Venta getVenta() {
    return venta;
  }
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
    _loaddetalleVenta(widget.getVenta());
    _loadProductos();
  }

  void _loaddetalleVenta(Venta venta) async {
    print("ventaaaa :${venta.idVenta}");
    detalleVenta =
        await DatabaseHelper.instance.retrieveDetallesVenta(venta.idVenta);
    setState(() {});
  }

  void _loadProductos() async {
    productos = await DatabaseHelper.instance.retrieveProductos();
    print("Reservas cargadas: $productos");

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
                  hint: Text("Seleccione un Producto"),
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
                      '${detalleVenta[index].idProducto.nombre} ${detalleVenta[index].cantidad}'),
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
          idDetalleVenta: 1, // id 0 porque SQLite lo autoincrementará
          idVenta: widget.getVenta(),
          idProducto: selectedProducto!,
          cantidad: int.parse(_controllerCantidad.text));
      await DatabaseHelper.instance.insertDetalleVenta(newDetalleVenta);
      _loaddetalleVenta(widget.getVenta());
      _controllerCantidad.clear();
    }
  }

  void _deleteDetalleVenta(int id) async {
    await DatabaseHelper.instance.deleteDetalleVenta(id);
    _loaddetalleVenta(widget.getVenta());
  }

  void _editDetalleVenta(int index) async {
    _controllerCantidad.text = detalleVenta[index].cantidad.toString();
    selectedProducto = detalleVenta[index].idProducto;

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
                    idVenta: detalleVenta[index].idVenta,
                    idProducto: selectedProducto!,
                    cantidad: int.parse(_controllerCantidad.text));
                await DatabaseHelper.instance
                    .updateDetalleVenta(updatedDetalleVenta);
                _loaddetalleVenta(widget.getVenta());
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
