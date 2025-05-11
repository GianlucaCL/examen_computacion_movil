import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cat = ModalRoute.of(context)!.settings.arguments as Category;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Categoría')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${cat.id}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Nombre: ${cat.name}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Estado: ${cat.state}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
