import 'package:flutter/material.dart';
import 'package:my_tienditapp/presentation/screens/login_screen.dart';
import 'package:my_tienditapp/presentation/screens/register_screen.dart';
import 'package:my_tienditapp/presentation/screens/home_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
