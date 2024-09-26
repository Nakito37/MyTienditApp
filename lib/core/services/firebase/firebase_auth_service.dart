import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Verificar el estado del usuario en tiempo real
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Iniciar sesión con email y contraseña
Future<User?> signInWithEmail(String email, String password) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    // Verificar si el correo está registrado
    if (user != null && user.emailVerified) {
      return user;
    } else {
      print('Por favor, verifica tu correo antes de iniciar sesión.');
      return null;
    }
  } on FirebaseAuthException catch (e) {
    print(e.message);
    return null;
  }
}


  // Registro con email y contraseña
Future<User?> registerWithEmail(String email, String password) async {
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    // Enviar correo de verificación
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print('Correo de verificación enviado');
    }

    return user;
  } on FirebaseAuthException catch (e) {
    print(e.message);
    return null;
  }
}


  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Obtener el usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
