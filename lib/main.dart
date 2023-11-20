import 'package:flutter/material.dart';
import 'package:flutter_frontend_final/src/screens/productos_screen.dart';

import 'package:flutter_frontend_final/src/screens/venta_screen.dart';

import '../src/screens/categoria_screen.dart';
import '../src/screens/cliente_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fichas Clínicas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fichas Clínicas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200, // Ancho fijo para todos los botones
              child: ElevatedButton(
                child: Text('Administrar Categorías'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoriaScreen(),
                  ));
                },
              ),
            ),
            SizedBox(
                width: 200, // Ancho fijo para todos los botones
                child: ElevatedButton(
                  child: Text('Administrar Productos'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductosScreen()));
                  },
                )),
            const SizedBox(height: 20),
            SizedBox(
              width: 200, // Ancho fijo para todos los botones
              child: ElevatedButton(
                child: Text('Administrar Clientes'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ClienteScreen(),
                  ));
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200, // Ancho fijo para todos los botones
              child: ElevatedButton(
                child: Text('Administrar Ventas'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VentaScreen(),
                  ));
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200, // Ancho fijo para todos los botones
              child: ElevatedButton(
                child: Text('Administrar Detalle Venta'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VentaScreen(),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
