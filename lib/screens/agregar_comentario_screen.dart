import 'package:flutter/material.dart';
import 'package:recetasapp/data/recetas_db.dart';
import 'package:recetasapp/models/comentario.dart';

class AgregarComentarioScreen extends StatefulWidget {
  final int recetaId;
  final Comentario? comentario;

  const AgregarComentarioScreen({
    super.key,
    required this.recetaId,
    this.comentario,
  });

  @override
  State<AgregarComentarioScreen> createState() => _AgregarComentarioScreenState();
}

class _AgregarComentarioScreenState extends State<AgregarComentarioScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _comentarioCtrl;
  late final TextEditingController _autorCtrl;
  bool get _esEdicion => widget.comentario != null;

  @override
  void initState() {
    super.initState();
    _comentarioCtrl = TextEditingController(text: widget.comentario?.comentario ?? '');
    _autorCtrl = TextEditingController(text: widget.comentario?.autor ?? '');
  }

  @override
  void dispose() {
    _comentarioCtrl.dispose();
    _autorCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final comentario = Comentario(
      id: widget.comentario?.id,
      recetaId: widget.recetaId,
      comentario: _comentarioCtrl.text.trim(),
      autor: _autorCtrl.text.trim(),
    );
    if (_esEdicion) {
      await RecetasDb.instancia.actualizar(comentario);
    } else {
      await RecetasDb.instancia.insert(comentario);
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar reseña' : 'Nueva reseña'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _comentarioCtrl,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Reseña',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.format_quote),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().length < 5)
                  ? 'Escribe al menos 5 caracteres'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _autorCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Autor',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Escribe el autor' : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.save),
              label: Text(_esEdicion ? 'Guardar cambios' : 'Guardar reseña'),
            ),
          ],
        ),
      ),
    );
  }
}