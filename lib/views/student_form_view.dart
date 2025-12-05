import 'package:flutter/material.dart';
import '../controllers/student_controller.dart';
import '../models/student.dart';

class StudentFormView extends StatefulWidget {
  final Student? student;
  final VoidCallback onSaved;

  const StudentFormView({super.key, this.student, required this.onSaved});

  @override
  State<StudentFormView> createState() => _StudentFormViewState();
}

class _StudentFormViewState extends State<StudentFormView> {
  final _formKey = GlobalKey<FormState>();
  final StudentController controller = StudentController();

  late TextEditingController nombreCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController programaCtrl;

  @override
  void initState() {
    super.initState();

    nombreCtrl = TextEditingController(text: widget.student?.nombre ?? "");
    emailCtrl = TextEditingController(text: widget.student?.email ?? "");
    programaCtrl = TextEditingController(text: widget.student?.programa ?? "");
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    emailCtrl.dispose();
    programaCtrl.dispose();
    super.dispose();
  }

  Future<void> saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.student == null) {
      // Crear estudiante nuevo
      await controller.addStudent(
        Student(
          id: "",
          nombre: nombreCtrl.text,
          email: emailCtrl.text,
          programa: programaCtrl.text,
          createdAt: DateTime.now(),
        ),
      );
    } else {
      // Actualizar
      await controller.updateStudent(
        Student(
          id: widget.student!.id,
          nombre: nombreCtrl.text,
          email: emailCtrl.text,
          programa: programaCtrl.text,
          createdAt: widget.student!.createdAt,
        ),
      );
    }

    widget.onSaved();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.student != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Editar Estudiante" : "Nuevo Estudiante"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Campo Nombre
                _buildInput(
                  controller: nombreCtrl,
                  label: "Nombre Completo",
                  icon: Icons.person,
                  validator: (value) =>
                      value!.isEmpty ? "Ingresa un nombre" : null,
                ),
                const SizedBox(height: 16),

                // Campo Email
                _buildInput(
                  controller: emailCtrl,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return "Ingresa un email";
                    if (!value.contains("@")) return "Email inválido";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Programa
                _buildInput(
                  controller: programaCtrl,
                  label: "Programa Académico",
                  icon: Icons.school,
                  validator: (value) =>
                      value!.isEmpty ? "Ingresa el programa" : null,
                ),
                const SizedBox(height: 30),

                // Botón
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEditing ? "Actualizar" : "Guardar",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // INPUT PERSONALIZADO
  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
