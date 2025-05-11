class ProviderModel {
  final int id;
  final String name;
  final String lastName;
  final String mail;
  final String state;

  ProviderModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.mail,
    required this.state,
  });

  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    // Manejar ambas posibilidades: 'provider_id' o 'providerid'
    int id;
    if (map.containsKey('providerid')) {
      id = map['providerid'] as int;
    } else if (map.containsKey('provider_id')) {
      id = map['provider_id'] as int;
    } else {
      // Si no existe ninguno de los dos, asignamos un valor por defecto
      print('Advertencia: No se encontró ID de proveedor en: $map');
      id = 0;
    }
    
    return ProviderModel(
      id: id,
      name: map['provider_name'] as String? ?? '',
      lastName: map['provider_last_name'] as String? ?? '',
      mail: map['provider_mail'] as String? ?? '',
      state: map['provider_state'] as String? ?? 'Activo',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'provider_id': id,
      'provider_name': name,
      'provider_last_name': lastName,
      'provider_mail': mail,
      'provider_state': state,
    };
  }
}
