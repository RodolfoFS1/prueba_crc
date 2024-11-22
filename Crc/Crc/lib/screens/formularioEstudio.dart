import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import "package:image_picker/image_picker.dart";
import 'dart:io';

class FormularioEstudio extends StatefulWidget {
  @override
  _FormularioEstudioState createState() => _FormularioEstudioState();
}

class _FormularioEstudioState extends State<FormularioEstudio> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de entrada de texto
  final TextEditingController motivoController = TextEditingController();
  final TextEditingController calleController = TextEditingController();
  final TextEditingController coloniaController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController nombreSolicitanteController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController ocupacionController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController escolaridadController = TextEditingController();
  final TextEditingController estadoCivilController = TextEditingController();
  final TextEditingController ingresoController = TextEditingController();

  // Variables para seleccionar género, sexo, y otras opciones
  String? selectedSexo;
  String? selectedGenero;
  String? selectedSituacionVivienda;
  String? selectedNivelSocioeconomico;

  // Listas de opciones
  final List<String> sexoOptions = ['Hombre', 'Mujer'];
  final List<String> generoOptions = [
    'Mujer cisgénero',
    'Hombre cisgénero',
    'Mujer trans',
    'Hombre trans',
    'Bigenero',
    'Fluido',
    'No binario',
    'Agénero',
    'Otro género',
    'Sin especificar'
  ];
  final List<String> situacionViviendaOptions = ['Propia', 'Pagándose', 'Rentada', 'Prestada'];
  final List<String> nivelSocioeconomicoOptions = ['Bajo', 'Medio-bajo', 'Medio', 'Alto'];

  // Controlador para la firma
  final SignatureController _signatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 2.0,
  );

  // Variables para las imágenes de identificación
  File? frontIdImage;
  File? backIdImage;

  // Método para seleccionar una imagen
  Future<void> _pickImage(ImageSource source, bool isFront) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          frontIdImage = File(pickedFile.path);
        } else {
          backIdImage = File(pickedFile.path);
        }
      });
    }
  }

  @override
  void dispose() {
    // Liberar los controladores
    motivoController.dispose();
    calleController.dispose();
    coloniaController.dispose();
    cpController.dispose();
    nombreSolicitanteController.dispose();
    fechaController.dispose();
    telefonoController.dispose();
    ocupacionController.dispose();
    edadController.dispose();
    escolaridadController.dispose();
    estadoCivilController.dispose();
    ingresoController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de estudio socioeconómico'),
        backgroundColor: Color(0xFF0192C8),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // Sección 1: Estudio Socioeconómico
            Text('Estudio Socioeconómico', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildTextField(motivoController, 'Motivo del estudio'),
            _buildTextField(calleController, 'Calle'),
            _buildTextField(coloniaController, 'Colonia'),
            _buildTextField(cpController, 'CP', keyboardType: TextInputType.number),
            _buildTextField(nombreSolicitanteController, 'Nombre del solicitante'),
            _buildTextField(fechaController, 'Fecha'),

             Row(
              children: [
                Expanded(child: _buildTextField(telefonoController, 'Teléfono')),
                SizedBox(width: 8),
                Expanded(child: _buildTextField(ocupacionController, 'Ocupación')),
                SizedBox(width: 8),
                Expanded(child: _buildTextField(edadController, 'Edad', keyboardType: TextInputType.number)),
                SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(sexoOptions, 'Sexo', selectedSexo, (value) {
                    setState(() { selectedSexo = value; });
                  }),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(child: _buildTextField(escolaridadController, 'Escolaridad')),
                SizedBox(width: 8),
                Expanded(child: _buildTextField(estadoCivilController, 'Estado Civil')),
                SizedBox(width: 8),
                Expanded(child: _buildTextField(ingresoController, 'Ingreso sol')),
                SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(generoOptions, 'Género', selectedGenero, (value) {
                    setState(() { selectedGenero = value; });
                  }),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Sección 2: Datos de la integración familiar
            Text('Datos de la integración familiar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildTextField(null, 'Nombre'),
            _buildTextField(null, 'Sexo/Género'),
            _buildTextField(null, 'Parentesco'),
            _buildTextField(null, 'Edad', keyboardType: TextInputType.number),
            _buildTextField(null, 'Estado Civil'),
            _buildTextField(null, 'Escolaridad'),
            _buildTextField(null, 'Ocupación'),
            _buildTextField(null, 'Ingresos'),
            _buildTextField(null, 'Aportación'),

            SizedBox(height: 20),

            // Sección 3: Ingreso mensual
            Text('Ingreso mensual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildTextField(null, 'Suma de la aportación', keyboardType: TextInputType.number),
            _buildTextField(null, 'Luz', keyboardType: TextInputType.number),
            _buildTextField(null, 'Agua', keyboardType: TextInputType.number),
            _buildTextField(null, 'Gas', keyboardType: TextInputType.number),
            _buildTextField(null, 'Teléfono', keyboardType: TextInputType.number),
            _buildTextField(null, 'Créditos', keyboardType: TextInputType.number),
            _buildTextField(null, 'Medicinas', keyboardType: TextInputType.number),
            _buildTextField(null, 'Transporte/Gasolina', keyboardType: TextInputType.number),
            _buildTextField(null, 'Televisión de paga', keyboardType: TextInputType.number),
            _buildTextField(null, 'Renta', keyboardType: TextInputType.number),
            _buildTextField(null, 'Alimentación', keyboardType: TextInputType.number),
            _buildTextField(null, 'Escuela', keyboardType: TextInputType.number),
            _buildTextField(null, 'Internet', keyboardType: TextInputType.number),
            _buildTextField(null, 'Total', keyboardType: TextInputType.number, readOnly: true),

            SizedBox(height: 20),

            // Sección 4: Pertenencias
            Text('Pertenencias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildTextField(null, 'Vehículo'),
            _buildDropdown (situacionViviendaOptions, 'Situación de la vivienda', selectedSituacionVivienda, (value) {
              setState(() { selectedSituacionVivienda = value; });
            }),
            _buildTextField(null, 'Material de paredes'),
            _buildTextField(null, 'Material de techo'),
            _buildTextField(null, 'Material de piso'),
            _buildTextField(null, 'Número de cuartos', keyboardType: TextInputType.number),
            _buildDropdown(nivelSocioeconomicoOptions, 'Nivel Socioeconómico', selectedNivelSocioeconomico, (value) {
              setState(() { selectedNivelSocioeconomico = value; });
            }),
            _buildTextField(null, 'Observaciones', maxLength: 255),

            // Sección 5: Captura de fotos de identificación
            SizedBox(height: 20),
            Text('Identificación Oficial', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Foto frontal
            _buildImagePicker('Frente de la Identificación', frontIdImage, true),
            SizedBox(height: 10),

            // Foto trasera
            _buildImagePicker('Reverso de la Identificación', backIdImage, false),
            SizedBox(height: 20),

            // Sección 6: Firma
            Text('Firma', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Signature(
                controller: _signatureController,
                height: 200,
                backgroundColor: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _signatureController.clear();
                  },
                  child: Text('Limpiar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_signatureController.isNotEmpty) {
                      final signature = await _signatureController.toPngBytes();
                      if (signature != null) {
                        // Lógica para guardar la firma
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Firma guardada')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Por favor, firme antes de guardar')),
                      );
                    }
                  },
                  child: Text('Guardar Firma'),
                ),
              ],
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Lógica para guardar datos
                }
              },
              child: Text('Guardar Formulario'),
            ),
          ],
        ),
      ),
    );
  }

  // Construir un campo de texto con validación
  Widget _buildTextField(
      TextEditingController? controller,
      String label, {
        TextInputType keyboardType = TextInputType.text,
        bool readOnly = false,
        int maxLength = 100,
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
        readOnly: readOnly,
        maxLength: maxLength,
      ),
    );
  }

  // Construir un campo para seleccionar imágenes
  Widget _buildImagePicker(String label, File? imageFile, bool isFront) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 10),
        imageFile != null
            ? Image.file(imageFile, height: 150, fit: BoxFit.cover)
            : Container(
                height: 150,
                color: Colors.grey[200],
                child: Center(child: Text('No hay imagen seleccionada')),
              ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera, isFront),
              child: Text('Cámara'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery, isFront),
              child: Text('Galería'),
            ),
          ],
        ),
      ],
    );
  }

// Construir un campo de selección (dropdown)
   Widget _buildDropdown(List<String> options, String label, String? selectedValue, Function(String?) onChanged) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 8.0),
       child: DropdownButtonFormField<String>(
         decoration: InputDecoration(
           labelText: label,
           border: OutlineInputBorder(),
         ),
         value: selectedValue,
         onChanged: onChanged,
         items: options.map<DropdownMenuItem<String>>((String value) {
           return DropdownMenuItem<String>(
             value: value,
             child: Text(value),
           );
         }).toList(),
       ),
     );
   }
}

