import 'package:flutter/material.dart';
import 'login.dart';
import 'apiService.dart';

class Usuario {
  String nombre;
  String email;
  String contrasena;
  int nivel;

  Usuario(this.nombre, this.email, this.contrasena, this.nivel);
}

class AdministrarAcceso extends StatefulWidget {
  final Login login;

  const AdministrarAcceso({Key? key, required this.login}) : super(key: key);

  @override
  _AdministrarAccesoState createState() => _AdministrarAccesoState();
}

class _AdministrarAccesoState extends State<AdministrarAcceso> {
  final ApiService apiService = ApiService(); // Instancia de ApiService
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  int? _nivelSeleccionado;

  List<Usuario> _usuarios = []; // Lista de usuarios

  void agregarUsuario() async {
    String username = _nombreController.text;
    String email = _emailController.text;
    String password = _contrasenaController.text;

    if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && _nivelSeleccionado != null) {
      Usuario nuevoUsuario = Usuario(username, email, password, _nivelSeleccionado!);
      try {
        await apiService.registerUser ({
          'nombre': username,
          'email': email,
          'pass': password,
          'nivel': _nivelSeleccionado,
        });
        setState(() {
          _usuarios.add(nuevoUsuario); // Agregar el nuevo usuario a la lista
          _nombreController.clear();
          _emailController.clear();
          _contrasenaController.clear();
          _nivelSeleccionado = null; // Reiniciar selección
        });
        Navigator.of(context).pop(); // Cerrar el diálogo
      } catch (e) {
        _showErrorPopup("Error al registrar el usuario: $e");
      }
    }
  }

  void mostrarDialogoAgregarUsuario() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del usuario',
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email del usuario',
                  ),
                ),
                TextField(
                  controller: _contrasenaController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña del usuario',
                    hintText: 'Ingresa una contraseña',
                  ),
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Nivel: '),
                    Radio(
                      value: 1,
                      groupValue: _nivelSeleccionado,
                      onChanged: (int? value) {
                        setState(() {
                          _nivelSeleccionado = value;
                        });
                      },
                    ),
                    Text('1'),
                    Radio(
                      value: 0,
                      groupValue: _nivelSeleccionado,
                      onChanged: (int? value) {
                        setState(() {
                          _nivelSeleccionado = value;
                        });
                      },
                    ),
                    Text('0'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: agregarUsuario,
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void eliminarUsuario(int index) {
    setState(() {
      _usuarios.removeAt(index); // Eliminar el usuario de la lista
    });
  }

  void mostrarDialogoEliminarUsuario() {
    if (_usuarios.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No hay usuarios'),
            content: Text('No hay usuarios para eliminar.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              children: _usuarios.map((usuario) {
                return ListTile(
                  title: Text(usuario.nombre),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      eliminarUsuario(_usuarios.indexOf(usuario));
                      Navigator.of(context).pop(); // Cerrar el diálogo
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void mostrarDialogoConsultarUsuarios() {
    if (_usuarios.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No hay usuarios'),
            content: Text('No hay usuarios para consultar.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Consultar Usuarios'),
          content: SingleChildScrollView(
            child: Column(
              children: _usuarios.map((usuario) {
                return ListTile(
                  title: Text(usuario.nombre),
                  subtitle: Text('Email: ${usuario.email} - Nivel: ${usuario.nivel}'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar Acceso'),
        backgroundColor: Color(0xFF0192C8),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: mostrarDialogoAgregarUsuario,
              child: Text('Agregar Usuario'),
            ),
            ElevatedButton(
              onPressed: mostrarDialogoEliminarUsuario,
              child: Text('Eliminar Usuario (${_usuarios.length})'), // Muestra la cantidad de usuarios
            ),
            ElevatedButton(
              onPressed: mostrarDialogoConsultarUsuarios,
              child: Text('Consultar Usuarios (${_usuarios.length})'), // Muestra la cantidad de usuarios
            ),
          ],
        ),
      ),
    );
  }
}