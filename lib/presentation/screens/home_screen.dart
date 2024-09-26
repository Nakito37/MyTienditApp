import 'package:flutter/material.dart';
import 'package:my_tienditapp/core/services/firebase/firebase_auth_service.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bienvenido a la aplicación, estás autenticado.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Puedes añadir aquí funcionalidades como ir a la pantalla de productos o finanzas
              },
              child: Text('Ir a gestionar productos'),
            ),
          ],
        ),
      ),
    );
  }
}
