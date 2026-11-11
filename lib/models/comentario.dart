class Comentario {
  final int? id;
  final int recetaId;
  final String comentario;
  final String autor;

  const Comentario({
    this.id,
    required this.recetaId,
    required this.comentario,
    required this.autor,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'recetaId': recetaId,
      'comentario': comentario,
      'autor': autor,
    };
  }

  factory Comentario.fromMap(Map<String, Object?> mapa) {
    return Comentario(
      id: mapa['id'] as int?,
      recetaId: mapa['recetaId'] as int,
      comentario: mapa['comentario'] as String,
      autor: mapa['autor'] as String,
    );
  }
}