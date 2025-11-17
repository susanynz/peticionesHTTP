import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeApiService {
  static const String _base = 'https://pokeapi.co/api/v2';

  final http.Client _client;
  PokeApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Pokemon> getPokemon(String idOrName) async {
    final id = idOrName.trim().toLowerCase();
    if (id.isEmpty) {
      throw ArgumentError('Proporciona un nombre o id de Pokémon');
    }

    final uri = Uri.parse('$_base/pokemon/$id');

    final resp = await _client
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 10));

    if (resp.statusCode == 200) {
      return Pokemon.fromResponseBody(resp.body);
    }

    if (resp.statusCode == 404) {
      throw Exception('No se encontró el Pokémon "$idOrName".');
    }

    throw Exception(
        'Error ${resp.statusCode} al consultar PokéAPI. Intenta de nuevo.');
  }

  void close() => _client.close();
}
