import 'package:flutter/material.dart';

import '../src/screens/categoria_screen.dart';

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
          ],
        ),
      ),
    );
  }
}
