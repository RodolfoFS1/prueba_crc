import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/formularioEstudio.dart';
import '../widgets/header.dart';
import 'administrarAcceso.dart';
import 'login.dart';
import 'registroDespensas.dart';

class HomeScreen extends StatefulWidget {
  final int userLevel; // Nivel del usuario
  final Login login;

  const HomeScreen({Key? key, required this.userLevel, required this.login}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variables para el calendario
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Variables para el clima
  String _weatherDescription = "Cargando...";
  double _temperature = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  // Método para obtener el clima desde una API (OpenWeatherMap)
  Future<void> _fetchWeather() async {
    const apiKey = "c6ec7c05ca40fb973d23572e64c688b9";
    const city = "Chihuahua";
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherDescription = data['weather'][0]['description'];
          _temperature = data['main']['temp'];
        });
      } else {
        setState(() {
          _weatherDescription = "Error al obtener el clima";
        });
      }
    } catch (e) {
      setState(() {
        _weatherDescription = "Error al conectar con la API";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Página Principal",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Clima
              SizedBox(
                height: 100,
                child: Card(
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.cloud, color: Colors.white, size: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Clima actual",
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              "$_weatherDescription",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              "${_temperature.toStringAsFixed(1)} °C",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Calendario
              SizedBox(
                height: 340,
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),
              // Grid de opciones
              LayoutBuilder(
                builder: (context, constraints) {
                  final tileWidth = constraints.maxWidth * 0.28;
                  final tileHeight = tileWidth * 1.2;

                  return GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
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
                              builder: (context) => FormularioEstudio(),
                            ),
                          );
                        },
                      ),
                      _buildTile(context, 'Mapa de despensas', Icons.map,
                          tileWidth, tileHeight, () {}),
                      _buildTile(context, 'Vales de entrada',
                          Icons.assignment_turned_in, tileWidth, tileHeight, () {}),
                      _buildTile(context, 'Vales de salida',
                          Icons.assignment_return, tileWidth, tileHeight, () {}),
                      _buildTile(context, 'Consulta vales', Icons.search,
                          tileWidth, tileHeight, () {}),
                      // Mostrar solo para usuarios nivel 1
                       if (widget.userLevel == 1)
                         _buildTile(
                           context,
                           'Administrar acceso',
                           Icons.admin_panel_settings,
                           tileWidth,
                           tileHeight,
                               () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => AdministrarAcceso(login: widget.login),
                               ),
                             );
                           },
                         ),
                    ],
                  );
                },
              ),
            ],
          ),
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
                Icon(icon, size: width * 0.5, color: Colors.white),
                SizedBox(height: height * 0.05),
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: width * 0.09),
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
                Icon(icon, size: width * 0.5, color: Colors.white),
                SizedBox(height: height * 0.05),
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: width * 0.09),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

