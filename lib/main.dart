import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_tienditapp/routes/routes.dart';
import 'firebase_options.dart';  // Importa el archivo generado para las opciones de Firebase


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tiendita App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Routes.generateRoute,
      initialRoute: '/login',
    );
  }
}
