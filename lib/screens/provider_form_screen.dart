import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider_provider.dart';
import '../models/provider.dart';

class ProviderFormScreen extends StatefulWidget {
  const ProviderFormScreen({super.key});

  @override
  State<ProviderFormScreen> createState() => _ProviderFormScreenState();
}

class _ProviderFormScreenState extends State<ProviderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mailController = TextEditingController();
  String _state = 'Activo';
  bool _isEditing = false;
  int _providerId = 0;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Verificar si recibimos un proveedor para editar
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is ProviderModel) {
      _isEditing = true;
      _providerId = args.id;
      _nameController.text = args.name;
      _lastNameController.text = args.lastName;
      _mailController.text = args.mail;
      _state = args.state;
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Proveedor' : 'Nuevo Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo de nombre
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Campo de apellido
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un apellido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Campo de email
                TextFormField(
                  controller: _mailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    hintText: 'ejemplo@correo.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un email';
                    }
                    if (!value.contains('@')) {
                      return 'Ingrese un email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Selector de estado
                DropdownButtonFormField<String>(
                  value: _state,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                    DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _state = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 30),
                
                // Botón de guardar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProvider,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(_isEditing ? 'Actualizar' : 'Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Future<void> _saveProvider() async {
    if (_formKey.currentState?.validate() != true) return;
    
    setState(() {
      _isLoading = true;
    });
    
    final providerProvider = Provider.of<ProviderProvider>(context, listen: false);
    
    final provider = ProviderModel(
      id: _providerId,
      name: _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      mail: _mailController.text.trim(),
      state: _state,
    );
    
    final success = await providerProvider.saveProvider(provider);
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Proveedor actualizado' : 'Proveedor creado')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(providerProvider.errorMessage)),
        );
      }
    }
  }
}
