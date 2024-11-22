import 'package:crc/screens/valesSalida.dart';
import 'package:flutter/material.dart';
import '../screens/formularioEstudio.dart';
import '../widgets/header.dart';
import 'login.dart';
import 'registroDespensas.dart';
import 'consultarVales.dart';
import 'valesSalida.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Header(
        isLoggedIn: true,
        onLogout: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login(onLogin: () {})),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tileWidth = constraints.maxWidth * 0.4;
            final tileHeight = tileWidth * 0.8;

            return GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: tileWidth / tileHeight,
              children: [
                _buildTile(
                  context,
                  'Registro de apoyos',
                  Icons.assignment,
                  tileWidth,
                  tileHeight,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistroDespensas(),
                      ),
                    );
                  },
                ),
                _buildTile(
                  context,
                  'Entrega de apoyos',
                  Icons.delivery_dining,
                  tileWidth,
                  tileHeight,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormularioEstudio(), // Navega a la pantalla del formulario
                      ),
                    );
                  },
                ),
                _buildTile(context, 'Mapa de despensas', Icons.map, tileWidth, tileHeight, () {}),
                _buildTile(context, 'Vales de entrada', Icons.assignment_turned_in, tileWidth, tileHeight, () {}),
                _buildTile(
                  context,
                  'Vales de salida',
                  Icons.assignment_return,
                  tileWidth,
                  tileHeight,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ValesSalida(),
                        ),
                    );
                    },
                ),
                _buildTile(
                    context,
                    'Consulta vales',
                    Icons.search,
                    tileWidth,
                    tileHeight,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConsultarVales(),
                        ),
                      );
                }),
                _buildTile(context, 'Administrar acceso', Icons.admin_panel_settings, tileWidth, tileHeight, () {}),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile(
      BuildContext context,
      String title,
      IconData icon,
      double width,
      double height,
      VoidCallback onTap,
      ) {
    return Container(
      width: width,
      height: height,
      child: Card(
        color: Color(0xFF0192C8),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: width * 0.4, color: Colors.white),
                SizedBox(height: height * 0.1),
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: width * 0.08),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
