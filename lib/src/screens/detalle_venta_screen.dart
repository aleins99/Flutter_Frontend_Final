import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/detalle_venta.dart';
import '../models/producto.dart';
import '../models/venta.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
  TextEditingController _controllercantidadDetalle =
      new TextEditingController();

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
                  controller: _controllercantidadDetalle,
                  decoration:
                      const InputDecoration(labelText: 'cantidadDetalle'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _addDetalleVenta,
                      child: const Text('Agregar'),
                    ),
                    ElevatedButton(
                        onPressed: _exportToPdf,
                        child: const Text(
                          'Exportar a PDF',
                        ))
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
                      '${detalleVenta[index].idProductoDetalle.nombre} ${detalleVenta[index].cantidadDetalle}'),
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

  void _exportToPdf() async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttf,
          italic: ttf,
          boldItalic: ttf,
        ),
        build: (context) => [
          pw.Table.fromTextArray(
            context: context,
            data: <List<String>>[
              [
                'Fecha',
                'Total',
                'idVenta',
                'Producto',
                'Categoría Producto',
                'Cantidad'
              ],
              ...detalleVenta.map((detalle) => [
                    '${detalle.idVentaDetalle.fecha}',
                    '${detalle.idVentaDetalle.total}',
                    '${detalle.idVentaDetalle.idVenta}',
                    '${detalle.idProductoDetalle.nombre} ${detalle.idProductoDetalle.precio}',
                    detalle.idProductoDetalle.categoria.nombre,
                    '${detalle.cantidadDetalle}',
                  ]),
            ],
          ),
        ],
      ),
    );
    final output = await _localPath;
    final file = File("$output/ventas.pdf");
    await file.writeAsBytes(await pdf.save());
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void _addDetalleVenta() async {
    if (_controllercantidadDetalle.text.isNotEmpty &&
        selectedProducto != null) {
      DetalleVenta newDetalleVenta = DetalleVenta(
          idDetalleVenta: 0, // id 0 porque SQLite lo autoincrementará
          idVentaDetalle: widget.getVenta(),
          idProductoDetalle: selectedProducto!,
          cantidadDetalle: int.parse(_controllercantidadDetalle.text));
      await DatabaseHelper.instance.insertDetalleVenta(newDetalleVenta);
      _loaddetalleVenta(widget.getVenta());
      _controllercantidadDetalle.clear();
    }
  }

  void _deleteDetalleVenta(int id) async {
    await DatabaseHelper.instance.deleteDetalleVenta(id);
    _loaddetalleVenta(widget.getVenta());
  }

  void _editDetalleVenta(int index) async {
    _controllercantidadDetalle.text =
        detalleVenta[index].cantidadDetalle.toString();
    selectedProducto = detalleVenta[index].idProductoDetalle;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar DetalleVenta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controllercantidadDetalle,
                decoration: const InputDecoration(
                  labelText: 'cantidadDetalle',
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
                    idVentaDetalle: detalleVenta[index].idVentaDetalle,
                    idProductoDetalle: selectedProducto!,
                    cantidadDetalle:
                        int.parse(_controllercantidadDetalle.text));
                await DatabaseHelper.instance
                    .updateDetalleVenta(updatedDetalleVenta);
                _loaddetalleVenta(widget.getVenta());
                Navigator.pop(context);
                _controllercantidadDetalle.clear();
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
