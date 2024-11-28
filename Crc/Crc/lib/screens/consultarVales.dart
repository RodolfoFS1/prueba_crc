import 'package:flutter/material.dart';

class ConsultarVales extends StatefulWidget {
  @override
  _BuscadorValesState createState() => _BuscadorValesState();
}

class _BuscadorValesState extends State<ConsultarVales> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _displayedVales = List.from(_mockVales);
  Map<String, dynamic>? _selectedVale;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() async {
    final term = _searchController.text;

    if (term.isNotEmpty) {
      try {
        // Simular una llamada al servidor
        await Future.delayed(Duration(milliseconds: 500));
        final results = _mockVales.where((vale) {
          final dependencia = vale['dependencia'];
          final solicitante = vale['solicitante'];
          final fecha = vale['fecha'];

          // Verificar si la dependencia, solicitante o fecha contiene el término de búsqueda
          if (dependencia != null && dependencia is String && dependencia.toLowerCase().contains(term.toLowerCase())) {
            return true;
          }
          if (solicitante != null && solicitante is String && solicitante.toLowerCase().contains(term.toLowerCase())) {
            return true;
          }
          if (fecha != null && fecha is String && fecha.contains(term)) { // Compara directamente la fecha
            return true;
          }
          return false;
        }).toList();
        setState(() {
          _displayedVales = results;
        });
      } catch (error) {
        print("Error al buscar los vales: $error");
      }
    } else {
      // Mostrar todos los vales recientes si no hay búsqueda
      setState(() {
        _displayedVales = List.from(_mockVales);
      });
    }
  }

  void _selectVale(Map<String, dynamic> vale) {
    setState(() {
      _selectedVale = vale;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedVale = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta Vales'),
        centerTitle: true,
        backgroundColor: Color(0xFF0192C8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por dependencia, solicitante o fecha',
                prefixIcon: Icon(Icons.search, color: Color(0xFF0192C8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _selectedVale == null
                  ? _buildValesList()
                  : _buildValeDetail(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValesList() {
    if (_displayedVales.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron resultados.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _displayedVales.length,
      itemBuilder: (context, index) {
        final vale = _displayedVales[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF0192C8),
              child: Icon(Icons.assignment, color: Colors.white),
            ),
            title: Text(
              vale['dependencia'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fecha: ${vale['fecha']}'),
                Text('Solicitante: ${vale['solicitante']}'),
              ],
            ),
            onTap: () => _selectVale(vale),
          ),
        );
      },
    );
  }

  Widget _buildValeDetail() {
    if (_selectedVale == null) return Container();

    final vale = _selectedVale!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalle del Vale',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Divider(thickness: 1, color: Color(0xFF0192C8)),
        SizedBox(height: 16),
        Text(
          'Fecha: ${vale['fecha']}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Dependencia: ${vale['dependencia']}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Solicitante: ${vale['solicitante']}',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
        Text(
          'Artículos Entregados:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ...vale['articulos']
            .map<Widget>((articulo) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF0192C8)),
              SizedBox(width: 8),
              Text(
                articulo,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ))
            .toList(),
        Spacer(),
        // Botón Volver centrado y con ancho completo
        Center(
          child: SizedBox(
            width: double.infinity, // Ancho completo
            child: ElevatedButton(
              onPressed: _clearSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0192C8), // Color del fondo del botón
                foregroundColor: Colors.white, // Color del texto
              ),
              child: Text('Volver'),
            ),
          ),
        ),
      ],
    );
  }
}

const _mockVales = [
  {
    'fecha': '2024-11-01',
    'dependencia': 'Escuela Primaria',
    'solicitante': 'Juan Pérez',
    'articulos': ['Despensas: 10', 'Mochilas: 5']
  },
  {
    'fecha': '2024-11-05',
    'dependencia': 'Secundaria Técnica',
    'solicitante': 'María López',
    'articulos': ['Colchonetas: 15', 'Juguetes: 20']
  },
];
