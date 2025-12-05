class Student {
  final String id;
  final String nombre;
  final String email;
  final String programa;
  final DateTime? createdAt;

  Student({
    required this.id,
    required this.nombre,
    required this.email,
    required this.programa,
    this.createdAt,
  });

  // Convertir Supabase → Dart
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      programa: map['programa'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  // Convertir Dart → Supabase
  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'email': email, 'programa': programa};
  }
}
