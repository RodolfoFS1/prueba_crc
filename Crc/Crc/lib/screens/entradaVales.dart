import 'package:flutter/material.dart';
import 'apiService.dart';

class EntradaVales extends StatefulWidget {
  @override
  _EntradaValesState createState() => _EntradaValesState();
}

class _EntradaValesState extends State<EntradaVales> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  final Map<String, TextEditingController> _controllers = {
    "Fecha": TextEditingController(),
    "Solicitante": TextEditingController(),
    "Dependencia": TextEditingController(),
    "Despensas": TextEditingController(),
    "MochilaPrimaria": TextEditingController(),
    "MochilasSecundaria": TextEditingController(),
    "MochilasPreparatoria": TextEditingController(),
    "Colchonetas": TextEditingController(),
    "Aguas": TextEditingController(),
    "Pintura": TextEditingController(),
    "Impermeabilizante": TextEditingController(),
    "Bicicletas": TextEditingController(),
    "Mesas": TextEditingController(),
    "Sillas": TextEditingController(),
    "Dulces": TextEditingController(),
    "Piñatas": TextEditingController(),
    "Juguetes": TextEditingController(),
  };

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final formData = _controllers.map((key, controller) => MapEntry(key, controller.text));
      final hasItems = formData.entries
          .where((entry) => entry.key != "Fecha" && entry.key != "Solicitante" && entry.key != "Dependencia")
          .any((entry) => int.tryParse(entry.value) != null && int.parse(entry.value) > 0);

      if (!hasItems) {
        _showErrorPopup("Debe agregar al menos un artículo.");
        return;
      }

      try {
        await apiService.submitValeEntrada(formData);
        _resetForm();
        _showSuccessPopup();
      } catch (e) {
        _showErrorPopup("Error al guardar el vale: $e");
      }
    }
  }

  void _resetForm() {
    _controllers.forEach((key, controller) {
      controller.clear();
    });
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Vale guardado"),
          content: Text("Vale de entrada generado exitosamente."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Aceptar"),
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
        title: Text("Vale de entrada"),
        backgroundColor: Color(0xFF0192C8),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Fecha", "Selecciona la fecha", isDate: true),
              _buildTextField("Solicitante", "Nombre del solicitante"),
              _buildTextField("Dependencia", "Dependencia"),
              SizedBox(height: 20),
              Text(
                "Añade las cantidades de los artículos:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ..._buildArticleFields(),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0192C8)),
                    child: Text("Generar Vale de Entrada", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String name, String placeholder, {bool isDate = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[name],
        decoration: InputDecoration(
          labelText: placeholder,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (name == "Fecha" || name == "Solicitante" || name == "Dependencia") {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio';
            }
          }
          return null;
        },
        readOnly: isDate,
        onTap: isDate
            ? () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            _controllers[name]?.text = pickedDate.toIso8601String().split('T')[0];
          }
        }
            : null,
      ),
    );
  }

  List<Widget> _buildArticleFields() {
    const articles = [
      "Despensas",
      "MochilaPrimaria",
      "MochilasSecundaria",
      "MochilasPreparatoria",
      "Colchonetas",
      "Aguas",
      "Pintura",
      "Impermeabilizante",
      "Bicicletas",
      "Mesas",
      "Sillas",
      "Dulces",
      "Piñatas",
      "Juguetes",
    ];

    return articles.map((article) {
      return _buildTextField(article, article, isDate: false);
    }).toList();
  }
}