import 'package:flutter/material.dart';
// Ensure you have added the google_fonts package to your pubspec.yaml
// import 'package:google_fonts/google_fonts.dart';
import '../controllers/student_controller.dart';
import '../models/student.dart';
import 'student_form_view.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({super.key});

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  final StudentController controller = StudentController();
  late Future<List<Student>> studentsFuture;

  @override
  void initState() {
    super.initState();
    studentsFuture = controller.getStudents();
  }

  void refreshList() {
    setState(() {
      studentsFuture = controller.getStudents();
    });
  }

  // Helper function for styling based on program
  Color _getProgramColor(String program) {
    if (program.contains("Sistemas") || program.contains("Software")) {
      return Colors.teal.shade700;
    } else if (program.contains("Mecánica") || program.contains("Civil")) {
      return Colors.orange.shade700;
    }
    return Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a consistent, elegant primary color (Indigo)
      appBar: AppBar(
        title: const Text(
          "Gestión de Estudiantes",
          // style: GoogleFonts.lato(fontWeight: FontWeight.bold), // Optional: Use if google_fonts installed
        ),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        elevation: 0, // Flat app bar looks cleaner
      ),
      backgroundColor: Colors.grey.shade50, // Subtle background color

      body: FutureBuilder<List<Student>>(
        future: studentsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.indigo),
            );
          }

          final students = snapshot.data!;

          if (students.isEmpty) {
            return const Center(
              child: Text(
                "No hay estudiantes registrados",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final s = students[index];

              // 🌟 --- TARJETA MODERNA & ELEGANTE --- 🌟
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                // Add a subtle gradient and a deeper shadow
                decoration: BoxDecoration(
                  // color: Colors.white, // Replaced by gradient
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.indigo.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100, // Richer avatar background
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons
                          .person_outline, // Use an outlined icon for modernity
                      color: Colors.indigo,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    s.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        s.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getProgramColor(s.programa).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Programa: ${s.programa}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getProgramColor(
                              s.programa,
                            ), // Dynamic color
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Use a trailing widget for a cleaner row of actions within the ListTile structure
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.indigo,
                        ), // Use primary color for edit
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentFormView(
                                student: s,
                                onSaved: refreshList,
                              ),
                            ),
                          );
                        },
                        tooltip: 'Editar',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ), // Use a vibrant red for delete
                        onPressed: () async {
                          await controller.deleteStudent(s.id);
                          refreshList();
                        },
                        tooltip: 'Eliminar',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade500, // A vibrant accent color
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentFormView(onSaved: refreshList),
            ),
          );
        },
        tooltip: 'Añadir estudiante',
      ),
    );
  }
}
