import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/provider.dart';
import '../providers/provider_provider.dart';
import '../routes/app_routes.dart';

class ProvidersListScreen extends StatefulWidget {
  const ProvidersListScreen({super.key});

  @override
  State<ProvidersListScreen> createState() => _ProvidersListScreenState();
}

class _ProvidersListScreenState extends State<ProvidersListScreen> {
  @override
  void initState() {
    super.initState();
    // Usar un Future.microtask para evitar llamar a Provider.of durante el build
    Future.microtask(() {
      Provider.of<ProviderProvider>(context, listen: false).loadProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
      ),
      body: _ProviderListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.providerForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProviderListView extends StatelessWidget {
  const _ProviderListView();

  @override
  Widget build(BuildContext context) {
    final providerProvider = Provider.of<ProviderProvider>(context);

    if (providerProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (providerProvider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${providerProvider.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                providerProvider.loadProviders();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (providerProvider.providers.isEmpty) {
      return const Center(
        child: Text(
          'No hay proveedores registrados',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: providerProvider.providers.length,
      itemBuilder: (context, index) {
        final provider = providerProvider.providers[index];
        return _ProviderCard(provider: provider);
      },
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final ProviderModel provider;

  const _ProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          '${provider.name} ${provider.lastName}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Email: ${provider.mail}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('Estado: '),
                Chip(
                  label: Text(provider.state),
                  backgroundColor: provider.state == 'Activo'
                      ? Colors.green.shade100
                      : Colors.grey.shade300,
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.providerForm,
                  arguments: provider,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, provider),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.providerDetail,
            arguments: provider,
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, ProviderModel provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
            '¿Está seguro de eliminar al proveedor ${provider.name} ${provider.lastName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final providerProvider =
          Provider.of<ProviderProvider>(context, listen: false);
      final success = await providerProvider.deleteProvider(provider.id);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Proveedor eliminado correctamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(providerProvider.errorMessage)),
          );
        }
      }
    }
  }
}
