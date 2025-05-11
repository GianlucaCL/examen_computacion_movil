import 'package:flutter/material.dart';

class CardContainerDos extends StatelessWidget {
  final Widget child;

  const CardContainerDos({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 50),
        height: 350, // Reducido el tamaño a 350px de altura
        decoration: _imageCardDecoration(),
        child: child,
      ),
    );
  }
}

BoxDecoration _imageCardDecoration() => BoxDecoration(
      color: const Color.fromARGB(
          255, 245, 245, 245), // Un gris más claro para dar un toque moderno
      borderRadius: BorderRadius.circular(20), // Radio de bordes más pequeño
      boxShadow: const [
        BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5)), // Sombra más suave
      ],
    );
