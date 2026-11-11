import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/comentario.dart';

class RecetasDb {
  RecetasDb._();
  static final RecetasDb instancia = RecetasDb._();
  static const _nombreArchivo = 'misrecetas.db';
  static const _tabla = 'comentarios';
  Database? _db;

  // devuelve la bd abierta (la abre solo la primera vez). PdD: Singleton
  Future<Database> get _database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE $_tabla (
id INTEGER PRIMARY KEY AUTOINCREMENT,
recetaId INTEGER NOT NULL,
comentario TEXT NOT NULL,
autor TEXT NOT NULL
)
''');
      },
    );
  }

  Future<int> insert(Comentario comentario) async {
    final db = await _database;
    return db.insert(_tabla, comentario.toMap());
  }

  Future<List<Comentario>> obtenerPorReceta(int recetaId) async {
    final db = await _database;
    final filas = await db.query(
      _tabla,
      where: 'recetaId = ?',
      whereArgs: [recetaId],
      orderBy: 'id DESC',
    );
    return filas.map(Comentario.fromMap).toList();
  }

  Future<int> actualizar(Comentario comentario) async {
    final db = await _database;
    return db.update(
      _tabla,
      comentario.toMap(),
      where: 'id = ?',
      whereArgs: [comentario.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _database;
    return db.delete(_tabla, where: 'id = ?', whereArgs: [id]);
  }
}