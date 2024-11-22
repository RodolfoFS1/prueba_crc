import 'package:flutter/material.dart';
import 'login.dart';


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
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  int? _nivelSeleccionado;

  void agregarUsuario() {
    String username = _nombreController.text;
    String password = _contrasenaController.text;

    if (username.isNotEmpty && password.isNotEmpty && _nivelSeleccionado != null) {
      widget.login.agregarUsuario(username, password, _nivelSeleccionado!);
      setState(() {
        _nombreController.clear();
        _emailController.clear();
        _contrasenaController.clear();
        _nivelSeleccionado = null; // Reiniciar selección
      });
      Navigator.of(context).pop(); // Cerrar el diálogo
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar acceso'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: mostrarDialogoAgregarUsuario,
              child: Text('Agregar usuario'),
            ),
            // Otros botones para consultar y eliminar usuarios
          ],
        ),
      ),
    );
  }
}