import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student.dart';

class StudentController {
  final SupabaseClient supabase = Supabase.instance.client;

  final String table = 'estudiantes';

  // Obtener todos los estudiantes
  Future<List<Student>> getStudents() async {
    final response = await supabase.from(table).select();

    return response.map<Student>((data) => Student.fromMap(data)).toList();
  }

  // Agregar estudiante
  Future<void> addStudent(Student student) async {
    await supabase.from(table).insert(student.toMap());
  }

  // Actualizar estudiante
  Future<void> updateStudent(Student student) async {
    await supabase.from(table).update(student.toMap()).eq('id', student.id);
  }

  // Eliminar estudiante
  Future<void> deleteStudent(String id) async {
    await supabase.from(table).delete().eq('id', id);
  }
}
