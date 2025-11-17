import 'package:flutter/material.dart';
import '../services/poke_api_service.dart';
import '../models/pokemon.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _controller = TextEditingController(text: 'pikachu');
  late final PokeApiService _api;
  Future<Pokemon>? _future;

  @override
  void initState() {
    super.initState();
    _api = PokeApiService();
    _future = _api.getPokemon(_controller.text);
  }

  @override
  void dispose() {
    _api.close();
    _controller.dispose();
    super.dispose();
  }

  void _buscar() {
    setState(() {
      _future = _api.getPokemon(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('PokéDex Act 3.6')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _buscar(),
                    decoration: const InputDecoration(
                      labelText: 'Nombre o ID (ej. pikachu, 25)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _buscar,
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<Pokemon>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium!
                            .copyWith(color: theme.colorScheme.error),
                      ),
                    );
                  }
                  final p = snapshot.data!;
                  return ListView(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('#${p.id} • ${p.name}',
                                  style: theme.textTheme.headlineSmall),
                              const SizedBox(height: 16),
                              if (p.imageUrl.isNotEmpty)
                                Image.network(
                                  p.imageUrl,
                                  height: 180,
                                  fit: BoxFit.contain,
                                )
                              else
                                const Icon(Icons.image_not_supported, size: 96),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: p.types
                                    .map((t) => Chip(
                                          label: Text(t.toUpperCase()),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Actividad 3.6',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
