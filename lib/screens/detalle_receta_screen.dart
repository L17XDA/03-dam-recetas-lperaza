import 'package:flutter/material.dart';
import 'package:recetasapp/data/recetas_db.dart';
import 'package:recetasapp/models/comentario.dart';
import 'package:recetasapp/models/receta.dart';
import 'package:recetasapp/screens/agregar_comentario_screen.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;
  const DetalleRecetaScreen({super.key, required this.receta});

  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  final _db = RecetasDb.instancia;
  List<Comentario> _comentarios = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState(); {
      _cargar();
    }
  }

  Future<void> _cargar() async {
    final lista = await _db.obtenerPorReceta(widget.receta.id);
    if (!mounted) return;
    setState(() {
      _comentarios = lista;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario(Comentario? existente) async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AgregarComentarioScreen(
          recetaId: widget.receta.id,
          comentario: existente,
        ),
      ),
    );

    if (guardado == true) {
      await _cargar();
    }
  }


  @override
  Widget build(BuildContext context) {
    final receta = widget.receta;
    return Scaffold(
      appBar: AppBar(title: Text("Detalle de la receta"),),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(14),
            child: Image.network(
              receta.imagenUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Image.asset(
                "assets/images/plato-placeholder.jpg",
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16,),
          Wrap(
            spacing: 10,
            children: [
              Chip(label: Text('${receta.tiempoTotal} min')),
              Chip(label: Text(receta.dificultad)),
              Chip(label: Text(receta.cocina)),
              Chip(label: Text('${receta.calorias} kcal')),
            ],
          ),
          const SizedBox(height: 8,),
          const Text(
            "Ingredientes: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8,),
          ...receta.ingredientes.map(
            (ingrediente)=> Padding(padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 6, color: Colors.orange,),
                const SizedBox(height: 8,),
                Expanded(child: Text(ingrediente))
              ],
            ),)
          ),
          const SizedBox(height: 20,),
          const Text("Preparación: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
          const SizedBox(height: 8,),
          ...receta.instrucciones.asMap().entries.map(
            (entrada)=> Padding(padding: const EdgeInsetsGeometry.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.deepOrange,
                  child: Text(
                    '${entrada.key+1}',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(child: Text(entrada.value))
              ],
            ),)
          ),
          const SizedBox(height: 20,),
          Text(
            'Reseñas actuales :(${_comentarios.length})',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 24,),
          FilledButton.icon(
            onPressed: () => _abrirFormulario(null), 
            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.purple)),
            label: const Text('¿Que opinas?')
          ),
          
          const SizedBox(height: 8,),
          _mostrarComentarios(),
        ],
      ),
    );
  }

  Widget _mostrarComentarios() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_comentarios.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'Aún no hay reseñas.\nToca "Dejar una reseña" para agregar la primera.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _comentarios.length,
      itemBuilder: (context, i) {
        final f = _comentarios[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            onTap: () => _abrirFormulario(f),
            title: Text(
              '"${f.comentario}"',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            subtitle: Text('- ${f.autor}'),
          ),
        );
      },
    );
  }
}