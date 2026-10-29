import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recetasapp/models/receta.dart';

class RecipeService {
  static const String _baseUrl = 'https://dummyjson.com/recipes';

  Future<List<Receta>> obtenerRecetas() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> lista = data['recipes'];
      return lista.map((json) => Receta.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar recetas: ${response.statusCode}');
    }
  }
}