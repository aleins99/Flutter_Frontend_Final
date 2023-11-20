import 'package:flutter/material.dart';
import '../models/venta.dart';
import '../providers/database_helper.dart';
import '../models/detalle_venta.dart';
import 'package:intl/intl.dart';

class VentaScreen extends StatefulWidget {
  @override
  _VentaScreenState createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  List<Venta> ventas = [];
  Venta? selectedVenta;
  TextEditingController _controllerFecha = TextEditingController();
  TextEditingController _controllerFactura = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadVentas();
  }

  void _loadVentas() async {
    ventas = await DatabaseHelper.instance.retrieveVentas();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Administración de Ventas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _controllerFecha,
                  decoration: const InputDecoration(labelText: 'Fecha'),
                  keyboardType: TextInputType.datetime,
                  onTap: () => _selectDate(context),
                ),
                TextField(
                  controller: _controllerFactura,
                  decoration: const InputDecoration(labelText: 'Factura'),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _addVenta,
                      child: const Text('Agregar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ventas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${ventas[index].factura}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editVenta(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteVenta(ventas[index].idVenta),
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

  int _selectedVenta =
      -1; // Valor inicial para indicar que no hay venta seleccionada

  void mostrarDetallesVenta(BuildContext context, int idVenta) {
    setState(() {
      if (_selectedVenta == idVenta) {
        _selectedVenta = -1; // Si ya se seleccionó esta venta, se deselecciona
      } else {
        _selectedVenta =
            idVenta; // Selecciona la venta correspondiente al idVenta recibido
      }
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _controllerFecha.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
  }

  void _addVenta() async {
    if (_controllerFecha.text.isNotEmpty &&
        _controllerFactura.text.isNotEmpty) {
      Venta newVenta = Venta(
        idVenta: 0, // id 0 porque SQLite lo autoincrementará
        fecha: DateTime.parse(_controllerFecha.text),
        factura: _controllerFactura.text,
        total: 0,
      );

      await DatabaseHelper.instance.insertVenta(newVenta);
      _loadVentas();
      _controllerFactura.clear();
      _controllerFecha.clear();
    }
  }

  void _deleteVenta(int id) async {
    await DatabaseHelper.instance.deleteVenta(id);
    _loadVentas();
  }

  void _editVenta(int index) async {
    _controllerFecha.text = ventas[index].fecha.toString();
    _controllerFactura.text = ventas[index].factura;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Venta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controllerFecha,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                ),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _controllerFactura,
                decoration: const InputDecoration(
                  labelText: 'Factura',
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
                Venta updatedVenta = Venta(
                  idVenta: ventas[index].idVenta,
                  fecha: ventas[index].fecha,
                  factura: ventas[index].factura,
                  total: ventas[index].total,
                );
                await DatabaseHelper.instance.updateVenta(updatedVenta);
                _loadVentas();
                Navigator.pop(context);
                _controllerFactura.clear();
                _controllerFecha.clear();
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }
}
