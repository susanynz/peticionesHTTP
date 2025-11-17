import 'dart:convert';

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>? ?? {};
    final other = sprites['other'] as Map<String, dynamic>? ?? {};
    final official = (other['official-artwork'] ?? {}) as Map<String, dynamic>;

    final image = (official['front_default'] ??
            sprites['front_default'] ??
            '') as String;

    final typesList = (json['types'] as List<dynamic>? ?? [])
        .map((t) => (t['type']?['name'] ?? '') as String)
        .where((t) => t.isNotEmpty)
        .toList();

    return Pokemon(
      id: json['id'] as int,
      name: (json['name'] as String).toUpperCase(),
      imageUrl: image,
      types: typesList,
    );
  }

  static Pokemon fromResponseBody(String body) =>
      Pokemon.fromJson(jsonDecode(body) as Map<String, dynamic>);
}
