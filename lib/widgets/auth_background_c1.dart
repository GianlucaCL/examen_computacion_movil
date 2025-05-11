import 'package:flutter/material.dart';

class AuthBackgorundC1 extends StatelessWidget {
  const AuthBackgorundC1({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeScreen =
        MediaQuery.of(context).size; //obtiene el tamaño de la pantalla
    return Container(
      width: double.infinity,
      height: sizeScreen.height * 0.4, //40% de la pantalla
      decoration: orangeDecoration(),
    );
  }

  BoxDecoration orangeDecoration() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 163, 56, 224),
        Color.fromARGB(255, 97, 11, 210),
      ]));
}

class Buble extends StatelessWidget {
  const Buble({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 50,
      height: 50,
    );
  }
}
