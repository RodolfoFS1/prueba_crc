import 'package:flutter/material.dart';
import 'homeScreen.dart';
import '../widgets/header.dart';

class Login extends StatefulWidget {
  final VoidCallback onLogin;

  const Login({Key? key, required this.onLogin}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();

  // Método público para agregar usuarios
  void agregarUsuario(String username, String password, int nivel) {
    _LoginState? state = _LoginState._instance;
    state?.agregarUsuario(username, password, nivel);
  }
}

class _LoginState extends State<Login> {
  static _LoginState? _instance; // Singleton para exponer métodos

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Mapa de usuarios con niveles
  final Map<String, int> _userLevels = {
    'r': 1, // Nivel maestro
    'user1': 0, // Nivel básico
  };

  late int _userLevel;

  @override
  void initState() {
    super.initState();
    _instance = this; // Inicializar singleton
  }

  @override
  void dispose() {
    _instance = null; // Liberar singleton
    super.dispose();
  }

  void _handleLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Verifica las credenciales
    if (_userLevels.containsKey(username) && password == '123456') {
      _userLevel = _userLevels[username]!;

      // Navega a la pantalla principal con el nivel del usuario
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userLevel: _userLevel, login: widget)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos incorrectos')),
      );
    }
  }

  void agregarUsuario(String username, String password, int nivel) {
    setState(() {
      _userLevels[username] = nivel; // Agregar nuevo usuario
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        isLoggedIn: false,
        onLogout: () {},
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Fondologin.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SizedBox(
              height: 350,
              width: 350,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Usuario'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Contraseña'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _handleLogin,
                      child: Text('Iniciar sesión'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
