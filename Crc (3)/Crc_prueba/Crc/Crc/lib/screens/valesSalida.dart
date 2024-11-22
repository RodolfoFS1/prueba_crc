import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class ValesSalida extends StatefulWidget {
  @override
  _ValesSalidaState createState() => _ValesSalidaState();
}

class _ValesSalidaState extends State<ValesSalida> {
  final _formKey = GlobalKey<FormState>();
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

  final SignatureController _firmaEntregaController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  final SignatureController _firmaRecibeController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (!_hasSelectedAtLeastOneArticle()) {
        _showErrorPopup("Debe seleccionar al menos un artículo.");
        return;
      }

      final formData = _controllers.map((key, controller) => MapEntry(key, controller.text));
      final firmaEntregaBytes = await _firmaEntregaController.toPngBytes();
      final firmaRecibeBytes = await _firmaRecibeController.toPngBytes();

      if (firmaEntregaBytes != null && firmaRecibeBytes != null) {
        formData['Firma1'] = firmaEntregaBytes.toString();
        formData['Firma2'] = firmaRecibeBytes.toString();

        print('Datos del formulario: $formData');

        // Limpiar formulario y mostrar confirmación
        _resetForm();
        _showSuccessPopup();
      } else {
        _showErrorPopup("Debe firmar ambos campos.");
      }
    }
  }

  bool _hasSelectedAtLeastOneArticle() {
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

    return articles.any((article) => _controllers[article]?.text.isNotEmpty ?? false);
  }

  void _resetForm() {
    _controllers.forEach((key, controller) {
      controller.clear();
    });

    _firmaEntregaController.clear();
    _firmaRecibeController.clear();
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Vale guardado"),
          content: Text("Vale generado exitosamente."),
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
  void dispose() {
    _firmaEntregaController.dispose();
    _firmaRecibeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vale de Salida"),
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
                "Selecciona los artículos:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ..._buildArticleFields(),
              SizedBox(height: 20),
              _buildSignatureField("Firma de quien entrega:", _firmaEntregaController),
              ElevatedButton(
                onPressed: _firmaEntregaController.clear,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0192C8)),
                child: Text("Limpiar Firma", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              _buildSignatureField("Firma de quien recibe:", _firmaRecibeController),
              ElevatedButton(
                onPressed: _firmaRecibeController.clear,
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0192C8)),
                child: Text("Limpiar Firma", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0192C8)),
                    child: Text("Generar Vale de Salida", style: TextStyle(color: Colors.white)),
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

  Widget _buildSignatureField(String title, SignatureController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        Container(
          color: Colors.grey[200],
          height: 150,
          child: Signature(
            controller: controller,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
