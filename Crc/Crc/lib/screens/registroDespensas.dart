import 'package:flutter/material.dart';

class RegistroDespensas extends StatefulWidget {
  @override
  _RegistroDespensasState createState() => _RegistroDespensasState();
}

class _RegistroDespensasState extends State<RegistroDespensas> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController calleController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController coloniaController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  @override
  void dispose() {
    // Liberar los controladores
    nombreController.dispose();
    calleController.dispose();
    numeroController.dispose();
    coloniaController.dispose();
    cpController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Aquí puedes agregar la lógica para enviar los datos
      // a tu backend o base de datos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registro guardado exitosamente")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Despensas'),
        backgroundColor: Color(0xFF0192C8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(nombreController, 'Nombre'),
              _buildTextField(calleController, 'Calle'),
              _buildTextField(numeroController, 'Número'),
              _buildTextField(coloniaController, 'Colonia'),
              _buildTextField(cpController, 'CP', keyboardType: TextInputType.number),
              _buildTextField(telefonoController, 'Teléfono', keyboardType: TextInputType.phone),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0192C8),
                ),
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingrese $label';
          }
          return null;
        },
      ),
    );
  }
}
