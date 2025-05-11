import 'dart:convert';

class Product {
  Product({
    required this.listado,
  });

  List<Listado> listado;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) {
    // Manejar diferentes formatos de respuesta
    if (json.containsKey("Listado")) {
      return Product(
        listado: List<Listado>.from(json["Listado"].map((x) => Listado.fromMap(x))),
      );
    } else if (json.containsKey("Productos Listado")) {
      return Product(
        listado: List<Listado>.from(json["Productos Listado"].map((x) => Listado.fromMap(x))),
      );
    } else {
      // Si no encontramos una clave conocida, devolver una lista vacía
      print('Formato de respuesta desconocido: $json');
      return Product(listado: []);
    }
  }

  Map<String, dynamic> toMap() => {
        "Listado": List<dynamic>.from(listado.map((x) => x.toMap())),
      };
}

class Listado {
  Listado({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productState,
  });

  int productId;
  String productName;
  int productPrice;
  String productImage;
  String productState;

  factory Listado.fromJson(String str) => Listado.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Listado.fromMap(Map<String, dynamic> json) {
    // Manejar posibles valores nulos o tipos incorrectos
    return Listado(
      productId: json["product_id"] ?? json["productid"] ?? 0,
      productName: json["product_name"] ?? '',
      productPrice: json["product_price"] is int 
          ? json["product_price"] 
          : (json["product_price"] is String 
              ? int.tryParse(json["product_price"]) ?? 0 
              : 0),
      productImage: json["product_image"] ?? '',
      productState: json["product_state"] ?? 'Activo',
    );
  }

  Map<String, dynamic> toMap() => {
        "product_id": productId,
        "product_name": productName,
        "product_price": productPrice,
        "product_image": productImage,
        "product_state": productState,
      };

  Listado copy() => Listado(
      productId: productId,
      productName: productName,
      productPrice: productPrice,
      productImage: productImage,
      productState: productState);
}
