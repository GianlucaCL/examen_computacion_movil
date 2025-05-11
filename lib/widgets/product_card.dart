import 'package:flutter/material.dart';
import '../models/productos.dart';

class ProductCard extends StatelessWidget {
  final Listado product;
  final Widget? trailing;
  const ProductCard({Key? key, required this.product, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 100,
                height: double.infinity,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: FadeInImage(
                  image: NetworkImage(product.productImage),
                  placeholder: const AssetImage('assets/jar-loading.gif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${product.productPrice}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 5),
                  if (product.productState == 'bloqueado')
                    const Text(
                      'Producto bloqueado',
                      style: TextStyle(
                          color: Color.fromARGB(255, 79, 37, 218),
                          fontSize: 13),
                    )
                ],
              ),
            ),

            // Trailing widget (botón, ícono, etc.)
            if (trailing != null)
              Align(
                alignment: Alignment.center,
                child: trailing!,
              )
          ],
        ),
      ),
    );
  }
}
