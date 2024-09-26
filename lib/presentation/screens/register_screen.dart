import 'package:flutter/material.dart';
import 'package:my_tienditapp/core/services/firebase/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Validar formato de correo electrónico
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+'); // Asegura separar el usuario@dominio de un correo
    return emailRegex.hasMatch(email);
  }

  // Validar fortaleza de la contraseña
  bool isValidPassword(String password) {
    return password.length >= 6; // Mayor o igual a 6 caracteres
  }

void _register() async {
  setState(() {
    isLoading = true;
  });

  // Validar el formato del correo electrónico
  if (!isValidEmail(_emailController.text.trim())) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, ingresa un correo electrónico válido.'),
        backgroundColor: Colors.red,
      ),
    );
    setState(() {
      isLoading = false;
    });
    return;
  }

  // Validar fortaleza de la contraseña
  if (!isValidPassword(_passwordController.text.trim())) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('La contraseña debe tener al menos 6 caracteres.'),
        backgroundColor: Colors.red,
      ),
    );
    setState(() {
      isLoading = false;
    });
    return;
  }

  // Verificar si las contraseñas coinciden
  if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Las contraseñas no coinciden.'),
        backgroundColor: Colors.red,
      ),
    );
    setState(() {
      isLoading = false;
    });
    return;
  }

  try {
    final user = await _authService.registerWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registro exitoso. Verifica tu correo electrónico para continuar.',
          ),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro fallido. Por favor, intenta nuevamente.')),
      );
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      isLoading = false;
    });

    String errorMessage;

    // Mostrar las excepciones controladas del registro
    if (e.code == 'email-already-in-use') {
      errorMessage = 'El correo ya ha sido registrado anteriormente.';
    } else if (e.code == 'weak-password') {
      errorMessage = 'La contraseña es débil.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'El correo no es válido.';
    } else {
      errorMessage = 'Ocurrió un error. Intenta nuevamente.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 80),
              Text(
                'My TienditApp - Gestiona tu negocio',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueGrey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                  labelText: 'Correo electrónico',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                  labelText: 'Contraseña',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                  labelText: 'Confirmar contraseña',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Registrar correo',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                          ),
                      ),
                    ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  '¿Ya perteneces al negocio? Inicia sesión',
                  style: TextStyle(color: Colors.blueGrey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
